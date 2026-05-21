<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $products = [
            [
                'name' => 'iPhone 14 Pro',
                'brand' => 'Apple',
                'category' => 'Smartphones',
                'price' => 1199.00,
                'rating' => 4.8,
                'image' => 'https://images.unsplash.com/photo-1671038374744-fe17decc8ea5?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                'description' => 'A16 Bionic chip, ProMotion display, 48MP camera.',
            ],
            [
                'name' => 'Galaxy S23 Ultra',
                'brand' => 'Samsung',
                'category' => 'Smartphones',
                'price' => 1099.00,
                'rating' => 4.7,
                'image' => 'https://fdn.gsmarena.com/imgroot/news/23/01/samsung-galaxy-s23-ultra-official/-1200/gsmarena_009.jpg',
                'description' => '200MP camera, Snapdragon 8 Gen 2, S Pen support.',
            ],
            [
                'name' => 'OnePlus 11',
                'brand' => 'OnePlus',
                'category' => 'Smartphones',
                'price' => 799.00,
                'rating' => 4.6,
                'image' => 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2X8eQEY1J30uhsQqmxYGZLKhkG0x3dQRBgA&s',
                'description' => 'Flagship performance with Snapdragon 8 Gen 2.',
            ],
            [
                'name' => 'MacBook Air M2',
                'brand' => 'Apple',
                'category' => 'Laptops',
                'price' => 1399.00,
                'rating' => 4.9,
                'image' => 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1200&auto=format&fit=crop',
                'description' => 'M2 chip, 18-hour battery, ultra‑thin design.',
            ],
            [
                'name' => 'Dell XPS 13',
                'brand' => 'Dell',
                'category' => 'Laptops',
                'price' => 1299.00,
                'rating' => 4.6,
                'image' => '/images/hp.jpg',
                'description' => 'Bezel-less display, Intel Evo platform performance.',
            ],
            [
                'name' => 'Apple Watch Series 8',
                'brand' => 'Apple',
                'category' => 'Smartwatches',
                'price' => 399.00,
                'rating' => 4.5,
                'image' => '/images/apple.jpg',
                'description' => 'Health tracking, crash detection, always‑on display.',
            ],
            [
                'name' => 'Galaxy Watch 6',
                'brand' => 'Samsung',
                'category' => 'Smartwatches',
                'price' => 329.00,
                'rating' => 4.4,
                'image' => 'https://images.unsplash.com/photo-1617043983671-adaadcaa2460?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
                'description' => 'Wear OS, advanced fitness insights, sleek design.',
            ],
            [
                'name' => 'Sony WH-1000XM5',
                'brand' => 'Sony',
                'category' => 'Accessories',
                'price' => 349.00,
                'rating' => 4.8,
                'image' => 'https://images.unsplash.com/photo-1755719401908-8612266b10c2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=688',
                'description' => 'Industry-leading noise cancelling headphones.',
            ],
            [
                'name' => 'AirPods Pro 2',
                'brand' => 'Apple',
                'category' => 'Accessories',
                'price' => 249.00,
                'rating' => 4.6,
                'image' => '/images/airpods.jpg',
                'description' => 'Active noise cancellation and spatial audio.',
            ],
            [
                'name' => 'Lenovo Legion 5',
                'brand' => 'Lenovo',
                'category' => 'Laptops',
                'price' => 1499.00,
                'rating' => 4.5,
                'image' => 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQj6nnzVe4XZPRTvAWQI0wRjiSlccIK3plK_1PCjq8KfE8bQ2GQlGmZ5KLHprHfVDe9ZHE&usqp=CAU',
                'description' => 'High performance gaming laptop with RTX graphics.',
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}

