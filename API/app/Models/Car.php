<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class Car extends Model
{
    protected $collection = 'car';

    protected $fillable = [
        'plate_en',
        'plate0',
        'plate1',
        'plate2',
        'plate3',
        'Plate_img',
        'car_img',
        'confidence',
        'camera_id',
        'entry_datetime',
        'status',
        'slot',
        'exit_datetime',
        'device'
    ];

    public $timestamps = false;
}
