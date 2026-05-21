<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CartController extends Controller
{
    public function index()
    {
        return view('cart');
    }

    public function getCart()
    {
        $carts = Cart::where('user_id', Auth::id())
            ->with('product')
            ->get();
        
        $items = $carts->map(function ($cart) {
            return [
                'id' => $cart->id,
                'product_id' => $cart->product_id,
                'name' => $cart->product->name,
                'brand' => $cart->product->brand,
                'category' => $cart->product->category,
                'price' => $cart->product->price,
                'image' => $cart->product->image,
                'quantity' => $cart->quantity,
            ];
        });

        return response()->json($items);
    }

    public function addToCart(Request $request)
    {
        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity' => 'integer|min:1|max:99',
        ]);

        $quantity = $validated['quantity'] ?? 1;

        $cart = Cart::firstOrNew([
            'user_id' => Auth::id(),
            'product_id' => $validated['product_id'],
        ]);

        if ($cart->exists) {
            $cart->quantity += $quantity;
        } else {
            $cart->quantity = $quantity;
        }

        $cart->save();

        return response()->json([
            'message' => 'Product added to cart',
            'cart' => $cart->load('product'),
        ]);
    }

    public function updateCart(Request $request, $id)
    {
        $validated = $request->validate([
            'quantity' => 'required|integer|min:1|max:99',
        ]);

        $cart = Cart::where('id', $id)
            ->where('user_id', Auth::id())
            ->firstOrFail();

        $cart->quantity = $validated['quantity'];
        $cart->save();

        return response()->json([
            'message' => 'Cart updated',
            'cart' => $cart->load('product'),
        ]);
    }

    public function removeFromCart($id)
    {
        $cart = Cart::where('id', $id)
            ->where('user_id', Auth::id())
            ->firstOrFail();

        $cart->delete();

        return response()->json(['message' => 'Item removed from cart']);
    }
}
