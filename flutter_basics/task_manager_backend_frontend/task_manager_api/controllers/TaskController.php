<?php

namespace app\controllers;

use yii\rest\ActiveController;
use yii\data\ActiveDataProvider;
use app\models\Task;
use Yii;

class TaskController extends ActiveController
{
    public $modelClass = 'app\models\Task';

    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['corsFilter'] = [
            'class' => \yii\filters\Cors::class,
        ];
        return $behaviors;
    }

    public function actions()
    {
        $actions = parent::actions();

        // customize the data provider preparation with the "prepareDataProvider()" method
        $actions['index']['prepareDataProvider'] = [$this, 'prepareDataProvider'];

        return $actions;
    }

    public function prepareDataProvider()
    {
        $query = Task::find();

        $status = Yii::$app->request->get('status');
        if (!empty($status)) {
            if (is_string($status) && strpos($status, ',') !== false) {
                $status = explode(',', $status);
            }
            $query->andWhere(['status' => $status]);
        }

        return new ActiveDataProvider([
            'query' => $query,
        ]);
    }
}
