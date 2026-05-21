<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Your Cart – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="cart">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
                <a href="{{ route('products') }}">Products</a>
                <a href="{{ route('cart') }}" class="active">Cart <span class="cart-badge" id="cartCount">0</span></a>
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
        <h1 class="page-title">Shopping Cart</h1>
        <div id="cartContainer" class="cart-grid">
            <!-- JS renders cart items and summary -->
        </div>
        <div class="cart-actions">
            <a class="btn btn-ghost" href="{{ route('products') }}">Continue Shopping</a>
            <button class="btn btn-primary" id="checkoutBtn">Checkout</button>
        </div>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>Secure shopping guaranteed.</p>
            </div>
        </div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
</body>
</html>


