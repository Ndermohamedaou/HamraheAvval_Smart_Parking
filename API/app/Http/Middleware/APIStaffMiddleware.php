<?php

namespace App\Http\Middleware;

use Closure;
use Tymon\JWTAuth\Facades\JWTAuth;

class APIStaffMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $user = JWTAuth::toUser($request->input('token'));
        if ($user->role != 'staff')
        {
            return response('403',403);
        }
        return $next($request);
    }
}
