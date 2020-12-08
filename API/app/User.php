<?php

namespace App;

use Illuminate\Contracts\Auth\CanResetPassword;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Contracts\Auth\Authenticatable;
use Jenssegers\Mongodb\Eloquent\Model;
use Illuminate\Auth\Authenticatable as AuthenticableTrait;
use Illuminate\Foundation\Auth\SendsPasswordResetEmails;

class User extends Model implements Authenticatable, JWTSubject, CanResetPassword
{
    use AuthenticableTrait, Notifiable;

    protected $collection = 'users';
    protected $primaryKey = '_id';

    protected $fillable = [
        'name', 'email', 'password', 'auth_token', 'last_login', 'role'
    ];

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }
    public function getJWTCustomClaims()
    {
        return [];
    }

    public function getStaffInfo()
    {
        return $this->hasOne('\App\Models\StaffInfo','user_id', '_id');
    }

    /**
     * @inheritDoc
     */
    public function getEmailForPasswordReset()
    {
        // TODO: Implement getEmailForPasswordReset() method.
    }

    /**
     * @inheritDoc
     */
    public function sendPasswordResetNotification($token)
    {
        // TODO: Implement sendPasswordResetNotification() method.
    }
}
