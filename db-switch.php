<?php

$wpConfigFile = '/Users/huntlycameron/docker/strut-wp/public_html/wordpress.test/wp-config.php';
if (!file_exists($wpConfigFile)) {
    echo "File not found: $wpConfigFile\n";
    exit(1);
}

if (count($argv) <= 1) {
    echo "No database selected\n";
    exit(1);
}

$args = array_slice($argv, 1);
$selectedDB = implode(' ', $args);

if(empty($selectedDB)) {
    echo "No database selected\n";
    exit(1);
}

$wpConfig = file_get_contents($wpConfigFile);

// comment out active
$wpConfig = preg_replace("/^define\(\s*'DB_NAME'\s*,\s*'(.*)'\s*\);/m", "// define( 'DB_NAME', '$1' );", $wpConfig);

// uncomment the selected db
$wpConfig = preg_replace("/^\/\/ define\(\s*'DB_NAME',(.*){$selectedDB}/m", "define('DB_NAME',$1{$selectedDB}", $wpConfig);

// write the wp-config.php file
file_put_contents($wpConfigFile, $wpConfig);

// exit cleanly
exit(0);
