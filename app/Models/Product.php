<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'brand',
        'category',
        'price',
        'rating',
        'image',
        'description',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'rating' => 'decimal:1',
    ];
}

