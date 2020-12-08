<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Slot;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DataController extends Controller
{
    public function getSlots()
    {
        $buildings = Slot::raw()->distinct('building');

        $data = [];

        foreach ($buildings as $key => $value)
        {
            $slots = Slot::where('building', $value)->get();

            foreach ($slots as $k => $v) {
                $data[$key][$value][$v->floor][] = [
                    'status' => $v->status,
                    'type' => $v->type,
                    'floor' => $v->floor,
                    'id' => $v->id,
                    'building' => $v->building,
                ];
            }
        }

        return response($data);
    }
}
