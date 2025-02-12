<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json'); // Force JSON output
error_reporting(0); // Hide PHP warnings

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "Smart_Education";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]);
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $action = $_POST["action"] ?? "";

    // CREATE
    if ($action == "insert") {
        $cgpa = $_POST["CGPA"] ?? "";
        $sub01 = $_POST["Subject_01"] ?? "";
        $sub01gpa = $_POST["Subject_01_GPA"] ?? "";
        $sub02 = $_POST["Subject_02"] ?? "";
        $sub02gpa = $_POST["Subject_02_GPA"] ?? "";
        $sub03 = $_POST["Subject_03"] ?? "";
        $sub03gpa = $_POST["Subject_03_GPA"] ?? "";
        $name = $_POST["Name"] ?? "";
        $birthday = $_POST["BirthDay"] ?? "";

        $sql = "INSERT INTO Result_Details (CGPA, Subject_01, Subject_01_GPA, Subject_02, Subject_02_GPA, Subject_03, Subject_03_GPA, Name, BirthDay) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("dsdsdsdss", $cgpa, $sub01, $sub01gpa, $sub02, $sub02gpa, $sub03, $sub03gpa, $name, $birthday);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Data inserted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Insertion failed"]);
        }
        $stmt->close();
        exit();
    }

    // READ
    elseif ($action == "read") {
        $result = $conn->query("SELECT * FROM Result_Details"); 
        $data = [];

        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }

        echo json_encode(["status" => "success", "data" => $data]);
        exit();
    }

    // DELETE
    elseif ($action == "delete") {
        $id = $_POST["ID"] ?? "";

        $sql = "DELETE FROM Result_Details WHERE ID=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $id);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Data deleted successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Deletion failed"]);
        }
        $stmt->close();
        exit();
    }

    // UPDATE
    elseif ($action == "update") {
        $id = $_POST["ID"] ?? "";
        $cgpa = $_POST["CGPA"] ?? "";
        $subject1_gpa = $_POST["Subject_01_GPA"] ?? "";
        $subject2_gpa = $_POST["Subject_02_GPA"] ?? "";
        $subject3_gpa = $_POST["Subject_03_GPA"] ?? "";

        if (empty($id) || empty($cgpa) || empty($subject1_gpa) || empty($subject2_gpa) || empty($subject3_gpa)) {
            echo json_encode(["status" => "error", "message" => "Missing required fields"]);
            exit();
        }

        $sql = "UPDATE Result_Details SET CGPA=?, Subject_01_GPA=?, Subject_02_GPA=?, Subject_03_GPA=? WHERE ID=?";
        $stmt = $conn->prepare($sql);

        if (!$stmt) {
            echo json_encode(["status" => "error", "message" => "SQL preparation failed"]);
            exit();
        }

        $stmt->bind_param("ddddd", $cgpa, $subject1_gpa, $subject2_gpa, $subject3_gpa, $id);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Data updated successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Update failed", "error" => $stmt->error]);
        }

        $stmt->close();
        exit();
    }

    // SUGGESTION
    elseif ($action == "suggestion") {
        if (!isset($_POST["CGPA"], $_POST["Subject_01"], $_POST["Subject_02"], $_POST["Subject_03"], $_POST["Subject_01_GPA"], $_POST["Subject_02_GPA"], $_POST["Subject_03_GPA"])) {
            echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
            exit();
        }

        $provided_cgpa = floatval($_POST["CGPA"]);
        $provide_sub1 = $_POST["Subject_01"];
        $provide_sub2 = $_POST["Subject_02"];
        $provide_sub3 = $_POST["Subject_03"];
        $provided_sub1gpa = floatval($_POST["Subject_01_GPA"]);
        $provided_sub2gpa = floatval($_POST["Subject_02_GPA"]);
        $provided_sub3gpa = floatval($_POST["Subject_03_GPA"]);

        $sql = "SELECT * FROM University_Requirement 
                WHERE CGPA <= ? 
                AND Subject_01 = ?
                AND Subject_02 = ?
                AND Subject_03 = ?  
                AND Subject_01_GPA <= ? 
                AND Subject_02_GPA <= ? 
                AND Subject_03_GPA <= ?";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("dsssddd", $provided_cgpa, $provide_sub1, $provide_sub2, $provide_sub3, $provided_sub1gpa, $provided_sub2gpa, $provided_sub3gpa);
        
        $stmt->execute();
        $result = $stmt->get_result();
        
        $suggested_universities = [];
        while ($university = $result->fetch_assoc()) {
            $suggested_universities[] = $university;
        }

        echo json_encode(["status" => "success", "data" => $suggested_universities]);

        $stmt->close();
        exit();
    }

    // INVALID ACTION
    else {
        echo json_encode(["status" => "error", "message" => "Invalid action"]);
        exit();
    }
}

// CLOSE CONNECTION
$conn->close();
?>
