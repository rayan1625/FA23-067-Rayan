<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>About – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="about">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
                <a href="{{ route('products') }}">Products</a>
                @auth
                    <a href="{{ route('cart') }}">Cart <span class="cart-badge" id="cartCount">0</span></a>
                @endauth
                <a href="{{ route('about') }}" class="active">About</a>
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
        <h1 class="page-title">About TechZone</h1>
        <div class="about-hero">
            <div class="about-copy">
                <p>TechZone is Pakistan’s modern online gadget store. We curate the latest smartphones, laptops, wearables, and accessories at competitive prices, backed by fast delivery and exceptional customer service.</p>
                <div class="about-stats">
                    <div class="stat"><strong>1500+</strong><span>Products</span></div>
                    <div class="stat"><strong>99%</strong><span>Happy Customers</span></div>
                    <div class="stat"><strong>50+</strong><span>Top Brands</span></div>
                </div>
            </div>
            <div class="about-media">
                <img loading="lazy" src="https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=1200&q=80" alt="Gadgets" />
            </div>
        </div>

        <div class="about-values">
            <div class="about-card">
                <h3>Our Mission</h3>
                <p>Empower everyone with cutting‑edge technology at fair prices.</p>
            </div>
            <div class="about-card">
                <h3>Quality First</h3>
                <p>Authentic products from trusted brands and sellers.</p>
            </div>
            <div class="about-card">
                <h3>Customer Focused</h3>
                <p>Hassle‑free returns, responsive support, and secure checkout.</p>
            </div>
        </div>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>Technology for everyone.</p>
            </div>
        </div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
</body>
</html>


