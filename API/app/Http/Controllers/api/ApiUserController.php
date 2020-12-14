<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Tymon\JWTAuth\Facades\JWTAuth;

class ApiUserController extends Controller
{

    public function User()
    {
        if (!$user = JWTAuth::parseToken()->authenticate()) {
            return response()->json(['user_not_found'], 404);
        }
        return $user;
    }

    public function UpdateInfo(Request $request)
    {
       $user = $this->User();

       $validator = \Validator::make($request->all(), [
            'avatar' => 'max:200|mimes:jpeg,png'
       ]);

       if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
       }

       if ($request->hasFile('avatar')) {
           $file = $request->file('avatar');
           $fileName = url('/avatars').'/'.Str::random(8).'-'.$file->getClientOriginalName();
           $imagePath = '/avatars';
           $file->move(public_path($imagePath), $fileName);
       }

       $user->name = $request->name ?? $user->name;
       $user->email = $request->email ?? $user->email;
       $user->password = bcrypt($request->password) ?? $user->password;

       $user->getStaffInfo->name = $request->name ?? $user->getStaffInfo->name;
       $user->getStaffInfo->email = $request->email ?? $user->getStaffInfo->email;
       $user->getStaffInfo->plate = $request->plate ?? $user->getStaffInfo->plate;

       $user->getStaffInfo->avatar = $fileName ?? $user->getStaffInfo->avatar;

       $user->getStaffInfo->birth_date = $request->birth_date ?? $user->getStaffInfo->birth_date;


       if ($user->getStaffInfo->save() && $user->save())
       {
           return response(['status' => '200'], 200);
       }else{
           return response(['status' => '500'], 500);
       }
    }

    public function getUserReserves()
    {
        $user = $this->User();

        $data = [];
        foreach ($user->getStaffInfo->getStaffReserves as $key => $value)
        {
            $data[$key] = [
                "plate" => $value->plate,
                "reserveTimeStart" => verta()->createTimestamp($value->reserveTimeStart)->format('Y-m-d H:i:s'),
                "reserveTimeEnd" => verta()->createTimestamp($value->reserveTimeEnd)->format('Y-m-d H:i:s'),
                "slot" => $value->slot,
                "building" => $value->building,
                "type" => $value->type,
                "status" => $value->status,
                "date" => $value->date
            ];
        }

        return response($data);

    }
}
