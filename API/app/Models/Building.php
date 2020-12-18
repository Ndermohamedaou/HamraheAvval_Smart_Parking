<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class Building extends Model
{
    protected $collection = 'Building';
    public $timestamps = false;
}
