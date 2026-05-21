<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Admin – TechZone</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}" />
</head>
<body data-page="admin">
    <header class="tz-header">
        <div class="container nav">
            <a class="logo" href="{{ route('home') }}">TechZone</a>
            <nav class="menu" id="navMenu">
                <a href="{{ route('home') }}">Home</a>
                <a href="{{ route('products') }}">Products</a>
                <a href="{{ route('cart') }}">Cart <span class="cart-badge" id="cartCount">0</span></a>
                <a href="{{ route('about') }}">About</a>
                <a href="{{ route('contact') }}">Contact</a>
                <a href="{{ route('admin') }}" class="active">Admin</a>
                <form method="POST" action="{{ route('logout') }}" style="display: inline;">
                    @csrf
                    <button type="submit" style="background: none; border: none; color: inherit; cursor: pointer; padding: 10px 12px; border-radius: 12px; font-size: inherit; font-family: inherit;">Logout ({{ auth()->user()->name }})</button>
                </form>
            </nav>
            <button class="hamburger" id="hamburger" aria-label="Toggle Menu">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="container">
        <h1 class="page-title">Admin Dashboard</h1>
        <div class="admin-grid">
            <form id="productForm" class="admin-form">
                <h3>Add / Edit Product</h3>
                <input type="hidden" id="productId" />
                <label>Name<input id="productName" required /></label>
                <label>Brand<input id="productBrand" required /></label>
                <label>Category<input id="productCategory" required /></label>
                <label>Price<input id="productPrice" type="number" min="0" required /></label>
                <label>Rating<input id="productRating" type="number" min="1" max="5" step="0.1" required /></label>
                <label>Image URL<input id="productImage" required /></label>
                <label>Description<textarea id="productDesc" rows="3"></textarea></label>
                <button class="btn btn-primary" type="submit">Save Product</button>
                <button class="btn btn-ghost" type="reset">Reset</button>
            </form>

            <div>
                <h3>Products</h3>
                <table class="table" id="adminTable">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Brand</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Rating</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="tz-footer">
        <div class="container footer-grid">
            <div>
                <h3>TechZone</h3>
                <p>Admin area (front-end only).</p>
            </div>
        </div>
    </footer>

    <script src="{{ asset('js/script.js') }}"></script>
</body>
</html>


