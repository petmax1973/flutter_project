<?php

use yii\db\Migration;

/**
 * Handles adding columns to table `{{%task}}`.
 */
class m260110_074727_add_column_to_task_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->addColumn('{{%task}}', 'assigned_to', $this->string());
        $this->addColumn('{{%task}}', 'priority', $this->integer()->defaultValue(1));
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        $this->dropColumn('{{%task}}', 'assigned_to');
        $this->dropColumn('{{%task}}', 'priority');
    }
}
