<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class Slot extends Model
{
    protected $collection = 'slot';
    protected $fillable = [
        'status',
        'type',
        'floor',
        'id',
        'building'
    ];

    public $timestamps = false;
}
