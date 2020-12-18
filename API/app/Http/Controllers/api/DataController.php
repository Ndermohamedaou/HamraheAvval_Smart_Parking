<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Building;
use App\Models\Camera;
use App\Models\Car;
use App\Models\Slot;
use Illuminate\Http\Request;

class DataController extends Controller
{

    function PersianToEnglish($srting,$toPersian=true)
    {
        $en_num = array('0','1','2','3','4','5','6','7','8','9','ي');
        $fa_num = array('۰','۱','۲','۳','۴','۵','۶','۷','۸','۹','ی');
        if( $toPersian ) return str_replace($en_num, $fa_num, $srting);
        else return str_replace($fa_num, $en_num, $srting);
    }

    public function getSlots($building)
    {
        $buildings = Slot::where('building',$building)->get();

        $data = [];

        foreach ($buildings as $key => $value)
        {
                $data[$value->floor][] = [
                    'status' => $value->status,
                    'type' => $value->type,
                    'floor' => $value->floor,
                    'id' => $value->id,
                    'key' => $value->ID,
                    'building' => $value->building,
                ];
        }

        return response($data);
    }

    public function getSlotInfo(Request $request)
    {
        $slot = Slot::where('id',$request->id)->first();

        if ($slot)
        {
            $data['status'] = [
                'status' => $slot->status,
                'type' => $slot->type,
                'floor' => $slot->floor,
                'id' => $slot->id,
                'building' => $slot->building
            ];

            if ($slot->status == 1)
            {
                $meta = Car::where('slot', $slot->id)->first();
                $data['meta'] = [
                    'plate_en' => $meta->plate_en,
                    'plate0' => $meta->plate0,
                    'plate1' => $meta->plate1,
                    'plate2' => $meta->plate2,
                    'plate3' => $meta->plate3,
                    'Plate_img' => $meta->Plate_img,
                    'car_img' => $meta->car_img,
                    'confidence' => $meta->confidence,
                    'camera_id' => $meta->camera_id,
                    'entry_datetime' => verta()->createTimestamp((int)$meta->entry_datetime)->format('Y-m-d H:i:s'),
                    'status' => $meta->status,
                    'slot' => $meta->slot,
                    'exit_datetime' => empty($meta->exit_datetime) ? '0' : verta()->createTimestamp((int)$meta->exit_datetime)->format('Y-m-d H:i:s'),
                    'device' => $meta->device
                ];
            }

            return response($data);

        }else{
            return response('404',404);
        }
    }

    public function searchSlot(Request $request)
    {
        if ($request->type == 'slot')
        {
            $slot = Slot::where('id',$request->slot)->first();

            if ($slot)
            {
                $data['status'] = [
                    'status' => $slot->status,
                    'type' => $slot->type,
                    'floor' => $slot->floor,
                    'id' => $slot->id,
                    'building' => $slot->building
                ];

                if ($slot->status == 1)
                {
                    $meta = Car::where('slot', $slot->id)->where('status', 1)->first();
                    if ($meta)
                        $data['meta'] = [
                            'plate_en' => $meta->plate_en,
                            'plate0' => $meta->plate0,
                            'plate1' => $meta->plate1,
                            'plate2' => $meta->plate2,
                            'plate3' => $meta->plate3,
                            'Plate_img' => $meta->Plate_img,
                            'car_img' => $meta->car_img,
                            'confidence' => $meta->confidence,
                            'camera_id' => $meta->camera_id,
                            'entry_datetime' => verta()->createTimestamp((int)$meta->entry_datetime)->format('Y-m-d H:i:s'),
                            'status' => $meta->status,
                            'slot' => $meta->slot,
                            'exit_datetime' => empty($meta->exit_datetime) ? '0' : verta()->createTimestamp((int)$meta->exit_datetime)->format('Y-m-d H:i:s'),
                            'device' => $meta->device
                        ];
                }

                return response($data);

            }else{
                return response('404',404);
            }
        }else{

            $car = new Car();

//            dd($request->all());
            $car = $car->where('status', 1)->where('plate0', $this->PersianToEnglish($request->plate0))->first();

            if ($request->plate1 != null)
            {
                $car = $car->where('plate1', $this->PersianToEnglish($request->plate1));
            }

            if ($request->plate2 != null)
            {
                $car = $car->where('plate2', $this->PersianToEnglish($request->plate2));
            }

            if ($request->plate3 != null)
            {
                $car = $car->where('plate3', $this->PersianToEnglish($request->plate3));
            }

            $car = $car->get();

//            dd($car);

            $data = [];
            foreach ($car as $key => $value)
            {
               $data[$key] = [
                   'plate_en' => $value->plate_en,
                   'plate0' => $value->plate0,
                   'plate1' => $value->plate1,
                   'plate2' => $value->plate2,
                   'plate3' => $value->plate3,
                   'Plate_img' => $value->Plate_img,
                   'car_img' => $value->car_img,
                   'confidence' => $value->confidence,
                   'camera_id' => $value->camera_id,
                   'entry_datetime' => verta()->createTimestamp((int)$value->entry_datetime)->format('Y-m-d H:i:s'),
                   'status' => $value->status,
                   'slot' => $value->slot,
                   'exit_datetime' => empty($value->exit_datetime) ? '0' : verta()->createTimestamp((int)$value->exit_datetime)->format('Y-m-d H:i:s'),
                   'device' => $value->device
               ];
            }

            return response($data, 200);
        }
    }

    public function getCameras()
    {
        return response(Camera::get(['ipCamera','type','status','location']));
    }

    public function getBuildings()
    {
        $buildings = Building::get(['name_en','name_fa','status']);

        return response($buildings);
    }
}
