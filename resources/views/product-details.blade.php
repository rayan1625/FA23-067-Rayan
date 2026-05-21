<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Product Details – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="product-details">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
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

    <main class="container">
        <div class="product-detail" id="productDetail">
            <div class="detail-media"><img src="{{ $product->image }}" alt="{{ $product->name }}"></div>
            <div class="detail-info">
                <h1>{{ $product->name }}</h1>
                <div class="muted">{{ $product->brand }} • {{ $product->category }}</div>
                <div class="rating" style="margin:6px 0" id="productRating" data-rating="{{ $product->rating }}"></div>
                <div class="price" style="font-size:1.6rem;margin:6px 0">${{ number_format($product->price, 2) }}</div>
                <p>{{ $product->description }}</p>
                <div class="specs">
                    <div>Warranty: 1 Year</div>
                    <div>Delivery: 3-5 days</div>
                    <div>Return: 7 days</div>
                    <div>Stock: In stock</div>
                </div>
                <div style="display:flex;gap:8px;margin-top:10px">
                    <button class="btn btn-primary" id="pdAdd" data-product-id="{{ $product->id }}">Add to Cart</button>
                    <a class="btn btn-ghost" href="{{ route('cart') }}">Go to Cart</a>
                </div>
            </div>
        </div>
        <section class="related">
            <h2 class="section-title">You may also like</h2>
            <div class="grid products-grid" id="relatedProducts">
                @foreach($relatedProducts as $related)
                    <div class="product-card">
                        <div class="product-thumb">
                            <img src="{{ $related->image }}" alt="{{ $related->name }}">
                            @if($related->price < 400)
                                <span class="badge">SALE</span>
                            @endif
                        </div>
                        <div class="product-body">
                            <div class="product-title">{{ $related->name }}</div>
                            <div class="muted">{{ $related->brand }} • {{ $related->category }}</div>
                            <div class="rating" id="rating-{{ $related->id }}" data-rating="{{ $related->rating }}"></div>
                            <div class="price">${{ number_format($related->price, 2) }}</div>
                            <div class="product-actions">
                                <a class="btn btn-ghost" href="{{ route('product.show', $related->id) }}">View Details</a>
                                <button class="btn btn-primary" data-add="{{ $related->id }}">Add to Cart</button>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        </section>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>Premium gadgets. Great value.</p>
            </div>
        </div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
</body>
</html>


