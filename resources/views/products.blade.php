<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Products – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="products">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
                <a href="{{ route('products') }}" class="active">Products</a>
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

    <main class="container">
        <h1 class="page-title">All Products</h1>
        
        @if(session('success'))
            <div style="background: #10b981; color: #052e1c; padding: 12px; border-radius: 12px; margin-bottom: 16px;">
                {{ session('success') }}
            </div>
        @endif

        <section class="filters" style="margin-bottom: 32px;">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 16px;">
                <div>
                    <label for="filterCategory" style="display: block; margin-bottom: 8px; font-weight: 500;">Category</label>
                    <select id="filterCategory" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px;">
                        <option value="">All Categories</option>
                    </select>
                </div>
                <div>
                    <label for="filterBrand" style="display: block; margin-bottom: 8px; font-weight: 500;">Brand</label>
                    <select id="filterBrand" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px;">
                        <option value="">All Brands</option>
                    </select>
                </div>
                <div>
                    <label for="priceMin" style="display: block; margin-bottom: 8px; font-weight: 500;">Min Price</label>
                    <input type="number" id="priceMin" placeholder="Min" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px;">
                </div>
                <div>
                    <label for="priceMax" style="display: block; margin-bottom: 8px; font-weight: 500;">Max Price</label>
                    <input type="number" id="priceMax" placeholder="Max" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px;">
                </div>
                <div>
                    <label for="searchBox" style="display: block; margin-bottom: 8px; font-weight: 500;">Search</label>
                    <input type="text" id="searchBox" placeholder="Search products..." style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px;">
                </div>
                <div style="display: flex; align-items: flex-end;">
                    <button id="applyPrice" class="btn btn-primary" style="width: 100%;">Apply Filters</button>
                </div>
            </div>
        </section>

        <section class="products-section">
            <div class="grid products-grid" id="productsGrid">
                <!-- Products will be loaded here by JavaScript -->
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
