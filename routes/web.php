<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\PageController;
use App\Http\Controllers\AuthController;

// Public routes
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::get('/products', [ProductController::class, 'index'])->name('products');
Route::get('/product/{id}', [ProductController::class, 'show'])->name('product.show');
Route::get('/about', [PageController::class, 'about'])->name('about');
Route::get('/contact', [PageController::class, 'contact'])->name('contact');

// Authentication routes
Route::get('/login', [AuthController::class, 'showLogin'])->name('login')->middleware('guest');
Route::post('/login', [AuthController::class, 'login'])->middleware('guest');
Route::get('/register', [AuthController::class, 'showRegister'])->name('register')->middleware('guest');
Route::post('/register', [AuthController::class, 'register'])->middleware('guest');
Route::post('/logout', [AuthController::class, 'logout'])->name('logout')->middleware('auth');

// Protected routes
Route::middleware('auth')->group(function () {
    Route::get('/cart', [CartController::class, 'index'])->name('cart');
});

// Admin routes
Route::middleware(['auth', 'admin'])->group(function () {
    Route::get('/admin', [AdminController::class, 'index'])->name('admin');
});

// API routes
Route::prefix('api')->group(function () {
    Route::get('/products', [ProductController::class, 'apiIndex'])->name('api.products.index');
    Route::get('/products/featured', [ProductController::class, 'featured'])->name('api.products.featured');
    
    // Protected cart API routes
    Route::middleware('auth')->group(function () {
        Route::get('/cart', [CartController::class, 'getCart'])->name('api.cart.get');
        Route::post('/cart', [CartController::class, 'addToCart'])->name('api.cart.add');
        Route::put('/cart/{id}', [CartController::class, 'updateCart'])->name('api.cart.update');
        Route::delete('/cart/{id}', [CartController::class, 'removeFromCart'])->name('api.cart.remove');
    });
    
    // Admin API routes
    Route::middleware(['auth', 'admin'])->group(function () {
        Route::post('/admin/products', [AdminController::class, 'store'])->name('api.admin.products.store');
        Route::put('/admin/products/{id}', [AdminController::class, 'update'])->name('api.admin.products.update');
        Route::delete('/admin/products/{id}', [AdminController::class, 'destroy'])->name('api.admin.products.destroy');
    });
});