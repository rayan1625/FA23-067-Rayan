// Shared UI helpers
const $ = (sel, ctx = document) => ctx.querySelector(sel);
const $$ = (sel, ctx = document) => Array.from(ctx.querySelectorAll(sel));

// Mobile menu
(() => {
  const hamburger = $('#hamburger');
  const nav = $('#navMenu');
  if (hamburger && nav) {
    hamburger.addEventListener('click', () => nav.classList.toggle('open'));
    $$('a', nav).forEach(a => a.addEventListener('click', () => nav.classList.remove('open')));
  }
})();

// Footer year
(() => {
  const yearEl = $('#year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();
})();

// API Base URL
const API_BASE = '/api';

// Get CSRF token
function getCsrfToken() {
  const meta = document.querySelector('meta[name="csrf-token"]');
  return meta ? meta.content : '';
}

// LocalStorage cart helpers (cart stays in localStorage for now)
const CART_KEY = 'techzone_cart_v1';

function loadCart(){
  try { return JSON.parse(localStorage.getItem(CART_KEY)) || {}; } catch { return {}; }
}
function saveCart(cart){ localStorage.setItem(CART_KEY, JSON.stringify(cart)); updateCartCount(); }
async function updateCartCount(){
  const isAuthenticated = document.querySelector('meta[name="csrf-token"]') !== null && 
                          document.body.innerHTML.includes('Logout');
  
  if (isAuthenticated) {
    try {
      const response = await fetch(`${API_BASE}/cart`, {
        headers: {
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      });
      if (response.ok) {
        const items = await response.json();
        const count = items.reduce((sum, item) => sum + item.quantity, 0);
        const el = $('#cartCount');
        if (el) el.textContent = String(count);
        return;
      }
    } catch (error) {
      console.error('Error fetching cart count:', error);
    }
  }
  
  // Fallback to localStorage for guests
  const cart = loadCart();
  const count = Object.values(cart).reduce((a,b)=>a+b,0);
  const el = $('#cartCount');
  if (el) el.textContent = String(count);
}
async function addToCart(id, qty=1){
  // Check if user is authenticated
  const isAuthenticated = document.querySelector('meta[name="csrf-token"]') !== null && 
                          (document.body.innerHTML.includes('Logout') || document.body.innerHTML.includes('auth()->user()'));
  
  if (isAuthenticated) {
    // Use database cart API
    try {
      const response = await fetch(`${API_BASE}/cart`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': getCsrfToken(),
          'Accept': 'application/json'
        },
        body: JSON.stringify({ product_id: id, quantity: qty }),
        credentials: 'same-origin'
      });
      if (response.ok) {
        await updateCartCount();
        return true;
      } else {
        const error = await response.json().catch(() => ({ message: 'Failed to add to cart' }));
        throw new Error(error.message || 'Failed to add to cart');
      }
    } catch (error) {
      console.error('Error adding to cart:', error);
      throw error;
    }
  } else {
    // Use localStorage for guests
    const cart = loadCart();
    cart[id] = (cart[id] || 0) + qty;
    saveCart(cart);
    return true;
  }
}
async function removeFromCart(id){
  const isAuthenticated = document.querySelector('meta[name="csrf-token"]') !== null && 
                          document.body.innerHTML.includes('Logout');
  
  if (isAuthenticated) {
    try {
      const response = await fetch(`${API_BASE}/cart/${id}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-TOKEN': getCsrfToken(),
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      });
      if (response.ok) {
        await updateCartCount();
        return true;
      }
    } catch (error) {
      console.error('Error removing from cart:', error);
    }
  } else {
    const cart = loadCart();
    delete cart[id];
    saveCart(cart);
  }
}
async function setQty(id, qty){
  const isAuthenticated = document.querySelector('meta[name="csrf-token"]') !== null && 
                          document.body.innerHTML.includes('Logout');
  
  if (isAuthenticated) {
    try {
      const response = await fetch(`${API_BASE}/cart/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': getCsrfToken(),
          'Accept': 'application/json'
        },
        body: JSON.stringify({ quantity: qty }),
        credentials: 'same-origin'
      });
      if (response.ok) {
        await updateCartCount();
        return true;
      }
    } catch (error) {
      console.error('Error updating cart:', error);
    }
  } else {
    const cart = loadCart();
    if (qty<=0) delete cart[id];
    else cart[id]=qty;
    saveCart(cart);
  }
}

// API Functions
async function fetchProducts(params = {}) {
  const queryString = new URLSearchParams(params).toString();
  const url = `${API_BASE}/products${queryString ? '?' + queryString : ''}`;
  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error('Failed to fetch products');
    return await response.json();
  } catch (error) {
    console.error('Error fetching products:', error);
    return [];
  }
}

async function fetchFeaturedProducts() {
  try {
    const response = await fetch(`${API_BASE}/products/featured`);
    if (!response.ok) throw new Error('Failed to fetch featured products');
    return await response.json();
  } catch (error) {
    console.error('Error fetching featured products:', error);
    return [];
  }
}

async function fetchProduct(id) {
  try {
    const response = await fetch(`${API_BASE}/products`);
    if (!response.ok) throw new Error('Failed to fetch product');
    const products = await response.json();
    return products.find(p => p.id == id) || null;
  } catch (error) {
    console.error('Error fetching product:', error);
    return null;
  }
}

async function saveProduct(productData) {
  const url = productData.id ? `${API_BASE}/admin/products/${productData.id}` : `${API_BASE}/admin/products`;
  const method = productData.id ? 'PUT' : 'POST';
  
  try {
    const response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': getCsrfToken(),
        'Accept': 'application/json'
      },
      body: JSON.stringify(productData),
      credentials: 'same-origin'
    });
    if (!response.ok) {
      const error = await response.json().catch(() => ({ message: 'Failed to save product' }));
      throw new Error(error.message || 'Failed to save product');
    }
    return await response.json();
  } catch (error) {
    console.error('Error saving product:', error);
    throw error;
  }
}

async function deleteProduct(id) {
  try {
    const response = await fetch(`${API_BASE}/admin/products/${id}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-TOKEN': getCsrfToken(),
        'Accept': 'application/json'
      },
      credentials: 'same-origin'
    });
    if (!response.ok) {
      const error = await response.json().catch(() => ({ message: 'Failed to delete product' }));
      throw new Error(error.message || 'Failed to delete product');
    }
    return true;
  } catch (error) {
    console.error('Error deleting product:', error);
    throw error;
  }
}

// Render helpers
function ratingStars(r){
  const full = Math.floor(r);
  const half = r - full >= 0.5;
  let s='';
  for(let i=0;i<full;i++) s+='★';
  if (half) s+='☆';
  while (s.length<5) s+='☆';
  return s;
}

function productCard(p){
  const price = parseFloat(p.price).toFixed(2);
  return `
  <div class="product-card">
    <div class="product-thumb">
      <img src="${p.image}" alt="${p.name}">
      ${parseFloat(p.price) < 400 ? '<span class="badge">SALE</span>' : ''}
    </div>
    <div class="product-body">
      <div class="product-title">${p.name}</div>
      <div class="muted">${p.brand} • ${p.category}</div>
      <div class="rating" aria-label="Rating ${p.rating}">${ratingStars(p.rating)}</div>
      <div class="price">$${price}</div>
      <div class="product-actions">
        <a class="btn btn-ghost" href="/product/${p.id}">View Details</a>
        <button class="btn btn-primary" data-add="${p.id}">Add to Cart</button>
      </div>
    </div>
  </div>`;
}

// Page routers
document.addEventListener('DOMContentLoaded', async () => {
  await updateCartCount();
  const page = document.body.getAttribute('data-page');
  
  // Render rating stars on all pages
  $$('.rating[data-rating]').forEach(el => {
    const rating = parseFloat(el.getAttribute('data-rating'));
    if (rating && !el.textContent.includes('★')) {
      el.innerHTML = ratingStars(rating);
      el.setAttribute('aria-label', `Rating ${rating}`);
    }
  });
  
  if (page === 'home') await initHome();
  if (page === 'products') await initProducts();
  if (page === 'product-details') await initProductDetails();
  if (page === 'cart') await initCart();
  if (page === 'admin') await initAdmin();
});

// HOME
async function initHome(){
  const container = $('#homeFeatured');
  if (!container) return;
  try {
    const products = await fetchFeaturedProducts();
    container.innerHTML = products.map(productCard).join('');
    bindAddButtons(container);
  } catch (error) {
    container.innerHTML = '<p>Error loading products. Please refresh the page.</p>';
  }
}

// PRODUCTS
async function initProducts(){
  const grid = $('#productsGrid');
  if (!grid) {
    console.error('Products grid not found');
    return;
  }

  const categorySel = $('#filterCategory');
  const brandSel = $('#filterBrand');
  const qMin = $('#priceMin');
  const qMax = $('#priceMax');
  const search = $('#searchBox');
  const applyBtn = $('#applyPrice');

  // Show loading state
  grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: var(--muted);">Loading products...</div>';

  // Load initial products to populate filters
  let allProducts = [];
  try {
    allProducts = await fetchProducts();
    if (allProducts.length === 0) {
      grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: var(--muted);">No products available.</div>';
      return;
    }
    
    if (categorySel) {
      populateSelect(categorySel, unique(allProducts.map(p=>p.category)));
    }
    if (brandSel) {
      populateSelect(brandSel, unique(allProducts.map(p=>p.brand)));
    }
  } catch (error) {
    console.error('Error loading products:', error);
    grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #ef4444;">Error loading products. Please refresh the page.</div>';
    return;
  }

  const params = new URLSearchParams(location.search);
  const preCat = params.get('category') || '';
  if (preCat && categorySel){ categorySel.value = preCat; }

  async function render(){
    const params = {};
    if (categorySel && categorySel.value) params.category = categorySel.value;
    if (brandSel && brandSel.value) params.brand = brandSel.value;
    if (qMin && qMin.value) params.min_price = qMin.value;
    if (qMax && qMax.value) params.max_price = qMax.value;
    if (search && search.value) params.search = search.value;

    try {
      const filtered = await fetchProducts(params);
      if (filtered.length === 0) {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: var(--muted);">No products found matching your filters.</div>';
      } else {
        grid.innerHTML = filtered.map(productCard).join('');
        bindAddButtons(grid);
      }
    } catch (error) {
      console.error('Error rendering products:', error);
      grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #ef4444;">Error loading products. Please try again.</div>';
    }
  }

  if (categorySel) categorySel.addEventListener('input', render);
  if (brandSel) brandSel.addEventListener('input', render);
  if (search) search.addEventListener('input', render);
  if (applyBtn) applyBtn.addEventListener('click', render);
  
  await render();
}

function populateSelect(sel, items){
  sel.innerHTML += items.map(v=>`<option value="${v}">${v}</option>`).join('');
}
function unique(arr){ return Array.from(new Set(arr)); }

// PRODUCT DETAILS
async function initProductDetails(){
  // Product details page is server-rendered, just add interactivity
  const pdAddBtn = $('#pdAdd');
  const productRating = $('#productRating');
  const related = $('#relatedProducts');
  
  // Render rating stars if element exists
  if (productRating) {
    const rating = parseFloat(productRating.getAttribute('data-rating') || 0);
    if (rating) {
      productRating.innerHTML = ratingStars(rating);
      productRating.setAttribute('aria-label', `Rating ${rating}`);
    }
  }
  
  // Add cart functionality
  if (pdAddBtn) {
    const productId = pdAddBtn.getAttribute('data-product-id');
    pdAddBtn.addEventListener('click', ()=>{ 
      if (productId) {
        addToCart(productId, 1); 
        alert('Added to cart'); 
      }
    });
  }
  
  // Render rating stars for related products
  if (related) {
    $$('.rating[data-rating]', related).forEach(ratingEl => {
      const rating = parseFloat(ratingEl.getAttribute('data-rating') || 0);
      if (rating && !ratingEl.textContent.includes('★')) {
        ratingEl.innerHTML = ratingStars(rating);
        ratingEl.setAttribute('aria-label', `Rating ${rating}`);
      }
    });
    bindAddButtons(related);
  }
}

// CART
async function initCart(){
  const mount = $('#cartContainer');
  const isAuthenticated = document.querySelector('meta[name="csrf-token"]') !== null && 
                          document.body.innerHTML.includes('Logout');
  
  async function render(){
    let items = [];
    
    if (isAuthenticated) {
      // Fetch from database
      try {
        const response = await fetch(`${API_BASE}/cart`, {
          headers: {
            'Accept': 'application/json'
          },
          credentials: 'same-origin'
        });
        if (response.ok) {
          items = await response.json();
        } else {
          mount.innerHTML = '<p>Error loading cart items.</p>';
          return;
        }
      } catch (error) {
        mount.innerHTML = '<p>Error loading cart items.</p>';
        return;
      }
    } else {
      // Use localStorage for guests
      const cart = loadCart();
      const productIds = Object.keys(cart);
      if (productIds.length === 0) {
        mount.innerHTML = `
          <div class="cart-items">
            <div style="padding:16px">Your cart is empty. <a href="{{ route('login') }}">Login</a> to save your cart.</div>
          </div>
          <aside class="cart-summary">
            <h3>Order Summary</h3>
            <div style="display:flex;justify-content:space-between"><span>Subtotal</span><strong>$0.00</strong></div>
            <div style="display:flex;justify-content:space-between"><span>Shipping</span><span>Calculated at checkout</span></div>
            <hr style="border-color:rgba(255,255,255,.08)">
            <div style="display:flex;justify-content:space-between;font-size:1.2rem"><span>Total</span><strong>$0.00</strong></div>
          </aside>
        `;
        return;
      }
      const allProducts = await fetchProducts();
      items = Object.entries(cart).map(([id,qty])=>{
        const p = allProducts.find(x=>x.id == id);
        return p ? { product_id: id, name: p.name, brand: p.brand, category: p.category, price: p.price, image: p.image, quantity: parseInt(qty) } : null;
      }).filter(Boolean);
    }
    
    if (items.length === 0) {
      mount.innerHTML = `
        <div class="cart-items">
          <div style="padding:16px">Your cart is empty.</div>
        </div>
        <aside class="cart-summary">
          <h3>Order Summary</h3>
          <div style="display:flex;justify-content:space-between"><span>Subtotal</span><strong>$0.00</strong></div>
          <div style="display:flex;justify-content:space-between"><span>Shipping</span><span>Calculated at checkout</span></div>
          <hr style="border-color:rgba(255,255,255,.08)">
          <div style="display:flex;justify-content:space-between;font-size:1.2rem"><span>Total</span><strong>$0.00</strong></div>
        </aside>
      `;
      return;
    }
    
    const subtotal = items.reduce((s,x)=> s + parseFloat(x.price)*x.quantity, 0);
    const itemId = isAuthenticated ? 'id' : 'product_id';
    
    mount.innerHTML = `
      <div class="cart-items">
        ${items.map(x=>`
          <div class="cart-item">
            <img src="${x.image}" alt="${x.name}" style="width:80px;height:80px;object-fit:cover;border-radius:10px;border:1px solid rgba(255,255,255,.06)">
            <div>
              <div style="font-weight:700">${x.name}</div>
              <div class="muted">${x.brand} • ${x.category}</div>
            </div>
            <div class="qty">
              <button class="btn btn-ghost" data-dec="${x[itemId]}">-</button>
              <input type="number" min="1" value="${x.quantity}" data-qty="${x[itemId]}">
              <button class="btn btn-ghost" data-inc="${x[itemId]}">+</button>
            </div>
            <div style="text-align:right">
              <div class="price">$${(parseFloat(x.price)*x.quantity).toFixed(2)}</div>
              <button class="btn btn-ghost" data-remove="${x[itemId]}">Remove</button>
            </div>
          </div>
        `).join('')}
      </div>
      <aside class="cart-summary">
        <h3>Order Summary</h3>
        <div style="display:flex;justify-content:space-between"><span>Subtotal</span><strong>$${subtotal.toFixed(2)}</strong></div>
        <div style="display:flex;justify-content:space-between"><span>Shipping</span><span>Calculated at checkout</span></div>
        <hr style="border-color:rgba(255,255,255,.08)">
        <div style="display:flex;justify-content:space-between;font-size:1.2rem"><span>Total</span><strong>$${subtotal.toFixed(2)}</strong></div>
      </aside>
    `;

    // Bind actions
    mount.addEventListener('click', async (e)=>{
      const t = e.target;
      if (t.matches('[data-inc]')){
        const id = t.getAttribute('data-inc');
        const input = mount.querySelector(`input[data-qty="${id}"]`);
        const newQty = parseInt(input.value) + 1;
        await setQty(id, newQty);
        render();
      }
      if (t.matches('[data-dec]')){
        const id = t.getAttribute('data-dec');
        const input = mount.querySelector(`input[data-qty="${id}"]`);
        const newQty = Math.max(1, parseInt(input.value) - 1);
        await setQty(id, newQty);
        render();
      }
      if (t.matches('[data-remove]')){
        const id = t.getAttribute('data-remove');
        await removeFromCart(id);
        render();
      }
    }, { once:true });
    
    $$('input[data-qty]', mount).forEach(inp=>{
      inp.addEventListener('input', async ()=>{
        await setQty(inp.getAttribute('data-qty'), Number(inp.value||1));
        render();
      });
    });
  }
  
  await render();

  const checkoutBtn = $('#checkoutBtn');
  if (checkoutBtn){
    checkoutBtn.addEventListener('click', async ()=>{
      const response = await fetch(`${API_BASE}/cart`, {
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      });
      const items = response.ok ? await response.json() : [];
      if (items.length === 0) return alert('Your cart is empty.');
      alert('Checkout is not implemented yet. This is a demo.');
    });
  }
}

// ADMIN
async function initAdmin(){
  const form = $('#productForm');
  const tableBody = $('#adminTable tbody');
  const idEl = $('#productId');
  const fields = {
    name: $('#productName'), brand: $('#productBrand'), category: $('#productCategory'),
    price: $('#productPrice'), rating: $('#productRating'), image: $('#productImage'), desc: $('#productDesc')
  };

  async function load(){
    try {
      const products = await fetchProducts();
      tableBody.innerHTML = products.map(p=>`
        <tr>
          <td>${p.name}</td><td>${p.brand}</td><td>${p.category}</td><td>$${parseFloat(p.price).toFixed(2)}</td><td>${p.rating}</td>
          <td>
            <button class="btn btn-ghost" data-edit="${p.id}">Edit</button>
            <button class="btn btn-ghost" data-del="${p.id}">Delete</button>
          </td>
        </tr>
      `).join('');
    } catch (error) {
      tableBody.innerHTML = '<tr><td colspan="6">Error loading products.</td></tr>';
    }
  }
  load();

  form.addEventListener('submit', async (e)=>{
    e.preventDefault();
    const productData = {
      name: fields.name.value.trim(),
      brand: fields.brand.value.trim(),
      category: fields.category.value.trim(),
      price: Number(fields.price.value),
      rating: Number(fields.rating.value),
      image: fields.image.value.trim(),
      description: fields.desc.value.trim() || ''
    };
    
    if (idEl.value) {
      productData.id = idEl.value;
    }

    try {
      await saveProduct(productData);
      form.reset(); 
      idEl.value='';
      await load();
      alert('Product saved');
    } catch (error) {
      alert('Error saving product. Please try again.');
    }
  });

  tableBody.addEventListener('click', async (e)=>{
    const t=e.target;
    if (t.matches('[data-edit]')){
      const id=t.getAttribute('data-edit');
      try {
        const products = await fetchProducts();
        const p = products.find(x=>x.id == id);
        if (!p) return;
        idEl.value=p.id; 
        fields.name.value=p.name; 
        fields.brand.value=p.brand; 
        fields.category.value=p.category;
        fields.price.value=p.price; 
        fields.rating.value=p.rating; 
        fields.image.value=p.image; 
        fields.desc.value=p.description || '';
        window.scrollTo({top:0,behavior:'smooth'});
      } catch (error) {
        alert('Error loading product for editing.');
      }
    }
    if (t.matches('[data-del]')){
      const id=t.getAttribute('data-del');
      if (!confirm('Delete this product?')) return;
      try {
        await deleteProduct(id);
        await load();
        alert('Product deleted');
      } catch (error) {
        alert('Error deleting product. Please try again.');
      }
    }
  });
}

// Utilities
function bindAddButtons(scope=document){
  scope.addEventListener('click', async (e)=>{
    const btn = e.target.closest('[data-add]');
    if (!btn) return;
    const id = btn.getAttribute('data-add');
    const originalText = btn.textContent;
    btn.textContent = 'Adding...';
    btn.disabled = true;
    
    try {
      await addToCart(id, 1);
      btn.textContent = 'Added ✓';
      setTimeout(()=>{ 
        btn.textContent = originalText;
        btn.disabled = false;
      }, 2000);
    } catch (error) {
      btn.textContent = 'Error';
      setTimeout(()=>{ 
        btn.textContent = originalText;
        btn.disabled = false;
      }, 2000);
    }
  });
}


