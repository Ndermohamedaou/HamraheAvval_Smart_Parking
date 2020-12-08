<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::group(['namespace' => 'Api'], function () {
    Route::post('login', 'ApiAuthController@login');
    Route::post('PasswordReset', 'ApiAuthController@PasswordReset');


});

Route::group(['middleware' => ['jwt'] , 'namespace' => 'Api'], function() {
    Route::get('userInfo', 'ApiAuthController@getAuthenticatedUser');
    Route::post('UpdateInfo', 'ApiUserController@UpdateInfo');
    Route::get('getUserReserves', 'ApiUserController@getUserReserves');
//        Route::get('closed', 'DataController@closed');
    Route::get('/getSlots','DataController@getSlots');
});

