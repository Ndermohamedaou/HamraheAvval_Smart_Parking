<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class Plate extends Model
{
    protected $collection = 'plates';
    protected $fillable = [
        'user_id',
        'plate0',
        'plate1',
        'plate2',
        'plate3',
        'status'
    ];

    public $timestamps = false;

    public function getStaffPlates()
    {
        return $this->belongsTo('App\Models\StaffInfo');
    }
}
