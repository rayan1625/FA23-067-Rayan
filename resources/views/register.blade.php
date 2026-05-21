<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Register – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="register">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
                <a href="{{ route('products') }}">Products</a>
                <a href="{{ route('cart') }}">Cart <span class="cart-badge" id="cartCount">0</span></a>
                <a href="{{ route('about') }}">About</a>
                <a href="{{ route('contact') }}">Contact</a>
            </nav>
            <button class="hamburger" id="hamburger" aria-label="Toggle Menu">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="container" style="max-width: 500px; margin: 40px auto;">
        <div class="contact-card">
            <h1 class="page-title" style="text-align: center;">Register</h1>
            
            @if($errors->any())
                <div style="background: #ef4444; color: #fff; padding: 12px; border-radius: 12px; margin-bottom: 16px;">
                    <ul style="margin: 0; padding-left: 20px;">
                        @foreach($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <form method="POST" action="{{ route('register') }}" class="contact-form">
                @csrf
                <div class="form-field">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" value="{{ old('name') }}" required autofocus />
                </div>
                <div class="form-field">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="{{ old('email') }}" required />
                </div>
                <div class="form-field">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required />
                    <small style="color: var(--muted); font-size: 0.875rem;">Minimum 8 characters</small>
                </div>
                <div class="form-field">
                    <label for="password_confirmation">Confirm Password</label>
                    <input type="password" id="password_confirmation" name="password_confirmation" required />
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">Register</button>
            </form>
            
            <div style="text-align: center; margin-top: 16px; color: var(--muted);">
                Already have an account? <a href="{{ route('login') }}" style="color: var(--brand-solid); font-weight: 600;">Login here</a>
            </div>
        </div>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>Your one-stop shop for the latest gadgets.</p>
            </div>
        </div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
</body>
</html>

