<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
        $featuredProducts = Product::orderBy('rating', 'desc')->limit(8)->get();
        return view('index', compact('featuredProducts'));
    }
}

