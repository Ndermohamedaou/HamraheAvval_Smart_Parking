<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class Camera extends Model
{
    protected $collection = 'Camera';
    public $timestamps = false;
}
