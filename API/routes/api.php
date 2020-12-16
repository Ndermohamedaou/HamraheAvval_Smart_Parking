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
    Route::post('logout', 'ApiAuthController@logout');
});

Route::group(['middleware' => ['jwt'] , 'namespace' => 'Api'], function() {

    Route::group(['middleware' => ['APIStaffMiddleware']], function() {
        Route::get('StaffInfo', 'ApiAuthController@getAuthenticatedUser'); //info staff ro az in estefade konid
        Route::post('UpdateInfo', 'ApiUserController@UpdateInfo');
        Route::get('getUserReserves', 'ApiUserController@getUserReserves');
        Route::get('Reserve', 'ApiUserController@Reserve');
        Route::get('getUserPlates', 'ApiUserController@getUserPlates');
        Route::post('addUserPlate', 'ApiUserController@addUserPlate');
    });

    Route::group(['middleware' => ['APISecurityMiddleware']], function() {
        Route::get('userInfo', 'ApiAuthController@getAuthenticatedUser'); // info security ro az in estefade konid
        Route::post('UpdateInfo', 'ApiUserController@UpdateInfo');
        Route::get('/getSlots','DataController@getSlots');
        Route::get('/getCameras','DataController@getCameras');
        Route::post('/getSlotInfo','DataController@getSlotInfo');
        Route::post('/searchSlot','DataController@searchSlot');
        Route::post('/uploadPlate','PlateController@uploadPlate');
    });

});

