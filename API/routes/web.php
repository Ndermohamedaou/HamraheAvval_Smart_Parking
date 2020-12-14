<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/add', function () {
//    $user = \App\User::create([
//       'name' => 'keivan shahkarami',
//       'email' => 'me@keiv.ir',
//       'password' => bcrypt('123'),
//       'role' => 'staff',
//        'last_login' => null
//    ]);
//
//    \App\Models\StaffInfo::create([
//        'user_id' => $user->_id,
//        'name' => $user->name,
//        'email' => $user->email,
//        'join_date' => verta()->today(),
//        'plate' => '75 ص 325 | 20',
//        'personal_code' => '902399',
//        'melli_code' => '4060776319',
//        'avatar' => 'Sample.jpg',
//        'section' => 'تحقیق و توسعه',
//        'birth_date' => '1374-01-23'
//    ]);

//    \App\Models\Reserve::create([
//        'plate' => '75 ص 325 | 20',
//        'reserveTimeStart' => time(),
//        'reserveTimeEnd' => time(),
//        'slot' => 'A7',
//        'building' => 'Hamrah',
//        'type' => '0',
//        'status' => '0',
//        'date' => verta()->today()->format('Y-m-d')
//    ]);

//    \App\Models\Slot::create([
//        "status"=> 0,
//        "type"=> 0,
//        "floor"=> "1",
//        "id"=> "A4",
//        "building"=> "vanak"
//    ]);
//
//    \App\Models\Slot::create([
//        "status"=> 0,
//        "type"=> 0,
//        "floor"=> "2",
//        "id"=> "B4",
//        "building"=> "vanak"
//    ]);

    \App\Models\Plate::create([
        'user_id' => '5fd51ff377270000b5000c46',
        'plate0' => '21',
        'plate1' => 'ب',
        'plate2' => '577',
        'plate3' => '31',
        'status' => '1'
    ]);

});

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
