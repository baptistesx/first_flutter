<?php
if (isset($_GET['test1']) and $_GET['test1'] == "?") {
    $arr = array('userId' => 3, 'id' => 2, 'title' => 'okok3');

    echo json_encode($arr);
    // echo '{"userId": 3, "id":2, "title":"okokok"}';
}
