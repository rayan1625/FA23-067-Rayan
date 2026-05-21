<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>TechZone – Online Gadget Store</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
    <link rel="icon" href="https://cdn-icons-png.flaticon.com/512/1041/1041916.png" />
    <meta name="description" content="TechZone – Buy smartphones, laptops, smartwatches and accessories online. Big Gadget Sale!" />
</head>
<body data-page="home">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}" class="active">Home</a>
                <a href="{{ route('products') }}">Products</a>
                @auth
                    <a href="{{ route('cart') }}">Cart <span class="cart-badge" id="cartCount">0</span></a>
                @endauth
                <a href="{{ route('about') }}">About</a>
                <a href="{{ route('contact') }}">Contact</a>
                @auth
                    @if(auth()->user()->isAdmin())
                        <a href="{{ route('admin') }}">Admin</a>
                    @endif
                    <form method="POST" action="{{ route('logout') }}" style="display: inline;">
                        @csrf
                        <button type="submit" style="background: none; border: none; color: inherit; cursor: pointer; padding: 10px 12px; border-radius: 12px; font-size: inherit; font-family: inherit;">Logout ({{ auth()->user()->name }})</button>
                    </form>
                @else
                    <a href="{{ route('login') }}">Login</a>
                    <a href="{{ route('register') }}">Register</a>
                @endauth
            </nav>
            <button class="hamburger" id="hamburger" aria-label="Toggle Menu">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="container hero-inner">
                <div class="hero-copy">
                    <h1>Big Gadget Sale</h1>
                    <p>Up to 50% off on top brands. Smartphones, laptops, smartwatches, and more.</p>
                    <div class="hero-cta">
                        <a href="{{ route('products') }}" class="btn btn-primary">Shop Now</a>
                        <a href="#categories" class="btn btn-ghost">Browse Categories</a>
                    </div>
                </div>
                <div class="hero-media">
                    <img loading="lazy" src="https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1600&q=80" alt="Gadgets banner" />
                </div>
            </div>
        </section>

        <section class="promo-strip">
            <div class="container promo-grid">
                <div class="promo-item">🚚 Free Shipping over $99</div>
                <div class="promo-item">🔒 Secure Payments</div>
                <div class="promo-item">↩️ 7‑Day Easy Returns</div>
            </div>
        </section>

        <section class="categories" id="categories">
            <div class="container">
                <h2 class="section-title">Featured Categories</h2>
                <div class="grid categories-grid">
                    <a class="category-card" href="{{ route('products') }}?category=Smartphones">
                        <img src="{{ asset('images/smartphones.jpg') }}" alt="Smartphones">
                        <div>
                            <h3>Smartphones</h3>
                            <p>Flagships and budget phones</p>
                        </div>
                    </a>
                    <a class="category-card" href="{{ route('products') }}?category=Laptops">
                        <img src="{{ asset('images/laptops.jpg') }}" alt="Laptops">
                        <div>
                            <h3>Laptops</h3>
                            <p>Ultrabooks and gaming rigs</p>
                        </div>
                    </a>
                    <a class="category-card" href="{{ route('products') }}?category=Smartwatches">
                        <img src="{{ asset('images/watches.jpg') }}" alt="Smartwatches">
                        <div>
                            <h3>Smartwatches</h3>
                            <p>Health and productivity</p>
                        </div>
                    </a>
                    <a class="category-card" href="{{ route('products') }}?category=Accessories">
                        <img loading="lazy" src="{{ asset('images/accessories.jpg') }}" alt="Accessories">
                        <div>
                            <h3>Accessories</h3>
                            <p>Chargers, earbuds, cases</p>
                        </div>
                    </a>
                </div>
            </div>
        </section>

        <section class="mini-banners">
            <div class="container grid mini-banners-grid">
                <a class="mini-banner" href="{{ route('products') }}?category=Smartphones">
                    <div class="mini-banner-content">
                        <h3>New Phones</h3>
                        <p>Latest releases in stock</p>
                    </div>
                </a>
                <a class="mini-banner alt" href="{{ route('products') }}?category=Laptops">
                    <div class="mini-banner-content">
                        <h3>Work & Play</h3>
                        <p>Top laptop deals</p>
                    </div>
                </a>
            </div>
        </section>

        <section class="featured-products">
            <div class="container">
                <h2 class="section-title">Featured Products</h2>
                <div class="grid products-grid" id="homeFeatured">
                    @foreach($featuredProducts as $product)
                        <div class="product-card">
                            <div class="product-thumb">
                                <img src="{{ $product->image }}" alt="{{ $product->name }}">
                                @if($product->price < 400)
                                    <span class="badge">SALE</span>
                                @endif
                            </div>
                            <div class="product-body">
                                <div class="product-title">{{ $product->name }}</div>
                                <div class="muted">{{ $product->brand }} • {{ $product->category }}</div>
                                <div class="rating" data-rating="{{ $product->rating }}" aria-label="Rating {{ $product->rating }}"></div>
                                <div class="price">${{ number_format($product->price, 2) }}</div>
                                <div class="product-actions">
                                    <a class="btn btn-ghost" href="{{ route('product.show', $product->id) }}">View Details</a>
                                    <button class="btn btn-primary" data-add="{{ $product->id }}">Add to Cart</button>
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>
        </section>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>Your one-stop shop for the latest gadgets.</p>
            </div>
            <div>
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="{{ route('home') }}">Home</a></li>
                    <li><a href="{{ route('products') }}">Products</a></li>
                    <li><a href="{{ route('about') }}">About</a></li>
                    <li><a href="{{ route('contact') }}">Contact</a></li>
                </ul>
            </div>
            <div>
                <h4>Follow Us</h4>
                <div class="socials">
                    <a href="#" aria-label="Facebook">&#x1F5E8;</a>
                    <a href="#" aria-label="Twitter">&#x1F426;</a>
                    <a href="#" aria-label="Instagram">&#x1F33A;</a>
                </div>
            </div>
        </div>
        <div class="copyright">© <span id="year"></span> TechZone. All rights reserved.</div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
</body>
</html>


