<?php

namespace App\Models;

use Jenssegers\Mongodb\Eloquent\Model;

class StaffInfo extends Model
{
    protected $collection = 'stave';

    protected $fillable = [
        'user_id',
        'name',
        'email',
        'join_date',
        'plate',
        'personal_code',
        'melli_code',
        'avatar',
        'section',
        'birth_date'
    ];

    public $timestamps = false;

    public function getStaffInfo()
    {
        return $this->belongsTo('\App\User');
    }

    public function getStaffReserves()
    {
        return $this->hasMany('\App\Models\Reserve','plate','plate');
    }
}
