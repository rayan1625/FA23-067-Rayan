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

// Dummy catalog data (could be moved to a separate JSON later)
const PRODUCTS = [
  {id:'p1', name:'iPhone 14 Pro', brand:'Apple', category:'Smartphones', price:1199, rating:4.8, image:'https://images.unsplash.com/photo-1671038374744-fe17decc8ea5?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170', desc:'A16 Bionic chip, ProMotion display, 48MP camera.'},
  {id:'p2', name:'Galaxy S23 Ultra', brand:'Samsung', category:'Smartphones', price:1099, rating:4.7, image:'https://fdn.gsmarena.com/imgroot/news/23/01/samsung-galaxy-s23-ultra-official/-1200/gsmarena_009.jpg', desc:'200MP camera, Snapdragon 8 Gen 2, S Pen support.'},
  {id:'p3', name:'OnePlus 11', brand:'OnePlus', category:'Smartphones', price:799, rating:4.6, image:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2X8eQEY1J30uhsQqmxYGZLKhkG0x3dQRBgA&s', desc:'A16 Bionic chip, ProMotion display, 48MP camera.'},
  {id:'p4', name:'MacBook Air M2', brand:'Apple', category:'Laptops', price:1399, rating:4.9, image:'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1200&auto=format&fit=crop', desc:'M2 chip, 18-hour battery, ultra‑thin design.'},
  {id:'p5', name:'Dell XPS 13', brand:'Dell', category:'Laptops', price:1299, rating:4.6, image:'images/hp.jpg', desc:'Bezel-less display, Intel Evo platform performance.'},
  {id:'p6', name:'Apple Watch Series 8', brand:'Apple', category:'Smartwatches', price:399, rating:4.5, image:'images/apple.jpg', desc:'Health tracking, crash detection, always‑on display.'},
  {id:'p7', name:'Galaxy Watch 6', brand:'Samsung', category:'Smartwatches', price:329, rating:4.4, image:'https://images.unsplash.com/photo-1617043983671-adaadcaa2460?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170', desc:'Wear OS, advanced fitness insights, sleek design.'},
  {id:'p8', name:'Sony WH-1000XM5', brand:'Sony', category:'Accessories', price:349, rating:4.8, image:'https://images.unsplash.com/photo-1755719401908-8612266b10c2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688', desc:'Industry-leading noise cancelling headphones.'},
  {id:'p9', name:'AirPods Pro 2', brand:'Apple', category:'Accessories', price:249, rating:4.6, image:'images/airpods.jpg', desc:'Active noise cancellation and spatial audio.'},
  {id:'p10', name:'Lenovo Legion 5', brand:'Lenovo', category:'Laptops', price:1499, rating:4.5, image:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQj6nnzVe4XZPRTvAWQI0wRjiSlccIK3plK_1PCjq8KfE8bQ2GQlGmZ5KLHprHfVDe9ZHE&usqp=CAU', desc:'High performance gaming laptop with RTX graphics.'},
];

// LocalStorage cart helpers
const CART_KEY = 'techzone_cart_v1';
const PRODUCTS_KEY = 'techzone_products_v1';

function loadCart(){
  try { return JSON.parse(localStorage.getItem(CART_KEY)) || {}; } catch { return {}; }
}
function saveCart(cart){ localStorage.setItem(CART_KEY, JSON.stringify(cart)); updateCartCount(); }
function updateCartCount(){
  const cart = loadCart();
  const count = Object.values(cart).reduce((a,b)=>a+b,0);
  const el = $('#cartCount');
  if (el) el.textContent = String(count);
}
function addToCart(id, qty=1){
  const cart = loadCart();
  cart[id] = (cart[id] || 0) + qty;
  saveCart(cart);
}
function removeFromCart(id){ const cart = loadCart(); delete cart[id]; saveCart(cart); }
function setQty(id, qty){ const cart = loadCart(); if (qty<=0) delete cart[id]; else cart[id]=qty; saveCart(cart); }

// Seed PRODUCTS in localStorage for Admin CRUD demo
(() => {
  if (!localStorage.getItem(PRODUCTS_KEY)) {
    localStorage.setItem(PRODUCTS_KEY, JSON.stringify(PRODUCTS));
  }
})();

function getAllProducts(){
  try {
    return JSON.parse(localStorage.getItem(PRODUCTS_KEY)) || PRODUCTS;
  } catch {
    return PRODUCTS;
  }
}
function saveAllProducts(list){ localStorage.setItem(PRODUCTS_KEY, JSON.stringify(list)); }

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
  return `
  <div class="product-card">
    <div class="product-thumb">
      <img src="${p.image}" alt="${p.name}">
      ${p.price < 400 ? '<span class="badge">SALE</span>' : ''}
    </div>
    <div class="product-body">
      <div class="product-title">${p.name}</div>
      <div class="muted">${p.brand} • ${p.category}</div>
      <div class="rating" aria-label="Rating ${p.rating}">${ratingStars(p.rating)}</div>
      <div class="price">$${p.price}</div>
      <div class="product-actions">
        <a class="btn btn-ghost" href="product-details.html?id=${encodeURIComponent(p.id)}">View Details</a>
        <button class="btn btn-primary" data-add="${p.id}">Add to Cart</button>
      </div>
    </div>
  </div>`;
}

// Page routers
document.addEventListener('DOMContentLoaded', () => {
  updateCartCount();
  const page = document.body.getAttribute('data-page');
  if (page === 'home') initHome();
  if (page === 'products') initProducts();
  if (page === 'product-details') initProductDetails();
  if (page === 'cart') initCart();
  if (page === 'admin') initAdmin();
});

// HOME
function initHome(){
  const container = $('#homeFeatured');
  if (!container) return;
  const list = getAllProducts().slice(0,8);
  container.innerHTML = list.map(productCard).join('');
  bindAddButtons(container);
}

// PRODUCTS
function initProducts(){
  const grid = $('#productsGrid');
  const list = getAllProducts();
  const categorySel = $('#filterCategory');
  const brandSel = $('#filterBrand');
  const qMin = $('#priceMin');
  const qMax = $('#priceMax');
  const search = $('#searchBox');
  const applyBtn = $('#applyPrice');

  populateSelect(categorySel, unique(list.map(p=>p.category)));
  populateSelect(brandSel, unique(list.map(p=>p.brand)));

  const params = new URLSearchParams(location.search);
  const preCat = params.get('category') || '';
  if (preCat){ categorySel.value = preCat; }

  function render(){
    const cat = categorySel.value;
    const brand = brandSel.value;
    const min = Number(qMin.value || 0);
    const max = Number(qMax.value || 1e9);
    const term = (search.value||'').toLowerCase();
    let filtered = list.filter(p => (!cat || p.category===cat) && (!brand || p.brand===brand) && p.price>=min && p.price<=max);
    if (term) filtered = filtered.filter(p => `${p.name} ${p.brand}`.toLowerCase().includes(term));
    grid.innerHTML = filtered.map(productCard).join('') || '<p>No products found.</p>';
    bindAddButtons(grid);
  }

  ;[categorySel,brandSel,search].forEach(el => el.addEventListener('input', render));
  applyBtn.addEventListener('click', render);
  render();
}

function populateSelect(sel, items){
  sel.innerHTML += items.map(v=>`<option value="${v}">${v}</option>`).join('');
}
function unique(arr){ return Array.from(new Set(arr)); }

// PRODUCT DETAILS
function initProductDetails(){
  const wrap = $('#productDetail');
  const related = $('#relatedProducts');
  if (!wrap) return;
  const id = new URLSearchParams(location.search).get('id');
  const list = getAllProducts();
  const p = list.find(x=>x.id===id) || list[0];
  if (!p) return;

  wrap.innerHTML = `
    <div class="detail-media"><img src="${p.image}" alt="${p.name}"></div>
    <div class="detail-info">
      <h1>${p.name}</h1>
      <div class="muted">${p.brand} • ${p.category}</div>
      <div class="rating" style="margin:6px 0">${ratingStars(p.rating)}</div>
      <div class="price" style="font-size:1.6rem;margin:6px 0">$${p.price}</div>
      <p>${p.desc}</p>
      <div class="specs">
        <div>Warranty: 1 Year</div>
        <div>Delivery: 3-5 days</div>
        <div>Return: 7 days</div>
        <div>Stock: In stock</div>
      </div>
      <div style="display:flex;gap:8px;margin-top:10px">
        <button class="btn btn-primary" id="pdAdd">Add to Cart</button>
        <a class="btn btn-ghost" href="cart.html">Go to Cart</a>
      </div>
    </div>
  `;

  $('#pdAdd').addEventListener('click', ()=>{ addToCart(p.id,1); alert('Added to cart'); });

  if (related){
    const suggestions = list.filter(x=>x.category===p.category && x.id!==p.id).slice(0,4);
    related.innerHTML = suggestions.map(productCard).join('');
    bindAddButtons(related);
  }
}

// CART
function initCart(){
  const mount = $('#cartContainer');
  const list = getAllProducts();
  function render(){
    const cart = loadCart();
    const items = Object.entries(cart).map(([id,qty])=>{
      const p = list.find(x=>x.id===id);
      return p ? { ...p, qty } : null;
    }).filter(Boolean);
    const subtotal = items.reduce((s,x)=> s + x.price*x.qty, 0);
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
              <button class="btn btn-ghost" data-dec="${x.id}">-</button>
              <input type="number" min="1" value="${x.qty}" data-qty="${x.id}">
              <button class="btn btn-ghost" data-inc="${x.id}">+</button>
            </div>
            <div style="text-align:right">
              <div class="price">$${(x.price*x.qty).toFixed(2)}</div>
              <button class="btn btn-ghost" data-remove="${x.id}">Remove</button>
            </div>
          </div>
        `).join('')}
        ${items.length===0?'<div style="padding:16px">Your cart is empty.</div>':''}
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
    mount.addEventListener('click', (e)=>{
      const t = e.target;
      if (t.matches('[data-inc]')){ const id=t.getAttribute('data-inc'); setQty(id, (loadCart()[id]||1)+1); render(); }
      if (t.matches('[data-dec]')){ const id=t.getAttribute('data-dec'); setQty(id, (loadCart()[id]||1)-1); render(); }
      if (t.matches('[data-remove]')){ const id=t.getAttribute('data-remove'); removeFromCart(id); render(); }
    }, { once:true });
    $$('input[data-qty]', mount).forEach(inp=>{
      inp.addEventListener('input', ()=>{ setQty(inp.getAttribute('data-qty'), Number(inp.value||1)); render(); });
    });
  }
  render();

  const checkoutBtn = $('#checkoutBtn');
  if (checkoutBtn){
    checkoutBtn.addEventListener('click', ()=>{
      const cart = loadCart();
      if (!Object.keys(cart).length) return alert('Your cart is empty.');
      alert('Checkout is not implemented yet. This is a demo.');
    });
  }
}

// ADMIN (front-end only)
function initAdmin(){
  const form = $('#productForm');
  const tableBody = $('#adminTable tbody');
  const idEl = $('#productId');
  const fields = {
    name: $('#productName'), brand: $('#productBrand'), category: $('#productCategory'),
    price: $('#productPrice'), rating: $('#productRating'), image: $('#productImage'), desc: $('#productDesc')
  };

  function load(){
    const list = getAllProducts();
    tableBody.innerHTML = list.map(p=>`
      <tr>
        <td>${p.name}</td><td>${p.brand}</td><td>${p.category}</td><td>$${p.price}</td><td>${p.rating}</td>
        <td>
          <button class="btn btn-ghost" data-edit="${p.id}">Edit</button>
          <button class="btn btn-ghost" data-del="${p.id}">Delete</button>
        </td>
      </tr>
    `).join('');
  }
  load();

  form.addEventListener('submit', (e)=>{
    e.preventDefault();
    const list = getAllProducts();
    const item = {
      id: idEl.value || `p${Date.now()}`,
      name: fields.name.value.trim(),
      brand: fields.brand.value.trim(),
      category: fields.category.value.trim(),
      price: Number(fields.price.value),
      rating: Number(fields.rating.value),
      image: fields.image.value.trim(),
      desc: fields.desc.value.trim() || '—'
    };
    const idx = list.findIndex(x=>x.id===item.id);
    if (idx>=0) list[idx]=item; else list.push(item);
    saveAllProducts(list);
    form.reset(); idEl.value='';
    load();
    alert('Product saved');
  });

  tableBody.addEventListener('click', (e)=>{
    const t=e.target;
    if (t.matches('[data-edit]')){
      const id=t.getAttribute('data-edit');
      const p=getAllProducts().find(x=>x.id===id);
      if (!p) return;
      idEl.value=p.id; fields.name.value=p.name; fields.brand.value=p.brand; fields.category.value=p.category;
      fields.price.value=p.price; fields.rating.value=p.rating; fields.image.value=p.image; fields.desc.value=p.desc;
      window.scrollTo({top:0,behavior:'smooth'});
    }
    if (t.matches('[data-del]')){
      const id=t.getAttribute('data-del');
      if (!confirm('Delete this product?')) return;
      const list=getAllProducts().filter(x=>x.id!==id);
      saveAllProducts(list);
      load();
    }
  });
}

// Utilities
function bindAddButtons(scope=document){
  scope.addEventListener('click', (e)=>{
    const btn = e.target.closest('[data-add]');
    if (!btn) return;
    const id = btn.getAttribute('data-add');
    addToCart(id,1);
    btn.textContent = 'Added';
    setTimeout(()=>{ btn.textContent='Add to Cart'; }, 1000);
  });
}


