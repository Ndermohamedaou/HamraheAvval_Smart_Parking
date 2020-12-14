<?php

namespace App\Http\Controllers\Api;
use App\Http\Controllers\Controller;

use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Password;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

class ApiAuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        try {
            if (! $token = JWTAuth::attempt($credentials)) {
                return response()->json(['error' => 'invalid_credentials'], 400);
            }
        } catch (JWTException $e) {
            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        $user = auth()->user();

        $first_visit = false;

        if (is_null($user->last_login))
        {
           $first_visit = true;
        }

        $user->last_login = verta()->today()->format('Y-m-d');
        $user->save();

        $data = [
            'status' => '200',
            'token' => $token,
            'first_visit' => $first_visit,
            'role' => $user->role,
        ];

        return response($data);
    }

    public function getAuthenticatedUser()
    {
        try {
            if (!$user = JWTAuth::parseToken()->authenticate()) {
                return response()->json(['user_not_found'], 404);
            }
        } catch (TokenExpiredException $e) {
            return response()->json(['token_expired']);
        } catch (TokenInvalidException $e) {
            return response()->json(['token_invalid']);
        } catch (JWTException $e) {
            return response()->json(['token_absent']);
        }

        $data = [
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'last_login' => empty($user->last_login) ? verta()->today()->format('Y-m-d') : $user->last_login,
            'plates' => $user->getStaffinfo->getStaffPlates ?? null,
            'personal_code' => $user->getStaffinfo->personal_code ?? null,
            'melli_code' => $user->getStaffinfo->melli_code ?? null,
            'avatar' => $user->getStaffinfo->avatar ?? null,
            'section' => $user->getStaffinfo->section ?? null,
            'birth_date' => $user->getStaffinfo->birth_date ?? null
        ];

        return response($data);
    }

    public function PasswordReset(Request $request)
    {
        $user = User::where('email', $request->email)->orWhere('personal_code', $request->email)->first();

        if ($user)
        {
//            $credentials['email'] = [$user->email];
//            dump(Password::sendResetLink($request->only('email')));

            return response('200', 200);

//            Mail::send('mail',  array('data' => $user), function($message) use ($user) {
//                $message->to($user->email, 'Reset Password')->subject('Smart Parking Password Reset');
//                $message->from('postmaster@sandboxe0485341b4994e2bbc0afef174afa19f.mailgun.org','MCI');
//            });
        }else{
            return response('404', 404);
        }
    }

    public function logout(Request $request)
    {
        if (JWTAuth::invalidate(JWTAuth::getToken()))
        {
            return response("200",200);
        }else{
            return response("500",500);
        }
    }
}
