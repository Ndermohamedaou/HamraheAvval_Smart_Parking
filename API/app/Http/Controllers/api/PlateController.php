<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Tymon\JWTAuth\Facades\JWTAuth;

class PlateController extends Controller
{

    public function User()
    {
        if (!$user = JWTAuth::parseToken()->authenticate()) {
            return response()->json(['user_not_found'], 404);
        }
        return $user;
    }

    public function uploadPlate(Request $request)
    {
        $user = $this->User();

        $validator = \Validator::make($request->all(), [
            'plate' => 'mimes:jpg,png'
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $file = $request->file('plate');
        $fileName = Str::random(8).'-'.$file->getClientOriginalName();
        $imagePath = "/plates";
        $file->move(public_path($imagePath), $fileName);

        $service_api = new Client();
        $endpoint = "http://localhost/api/CPRW";

        try {
            $response = $service_api->request('GET', $endpoint, ['query' => [
                'imageURi' => $imagePath,
                'token' => $user->email,
                'cameraState' => $request->state
            ]]);
        } catch (\Throwable $th) {
            return response(['status' => 'failed']);
        }

        $content = json_decode((string) $response->getBody(), true);
        return response($content);
    }
}
