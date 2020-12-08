<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class Reserve extends Model
{
    protected $collection = 'reserves';
    protected $fillable = [
      'plate',
      'reserveTimeStart',
      'reserveTimeEnd',
      'slot',
      'building',
      'type',
      'status',
      'date',
    ];

    public $timestamps = false;

    public function getStaffReserves()
    {
        return $this->belongsTo('App\Models\StaffInfo');
    }
}
