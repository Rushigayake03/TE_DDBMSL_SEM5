import java.sql.*;
import java.util.*;

public class DBConnect {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        try {
            // Step 1: Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Step 2: Establish connection
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/StudentDB", "root", "yourpassword");

            while (true) {
                System.out.println("\n1. Add  2. Display  3. Update  4. Delete  5. Exit");
                System.out.print("Enter choice: ");
                int ch = sc.nextInt();

                switch (ch) {
                    case 1: // ADD
                        System.out.print("Enter RollNo, Name, Marks: ");
                        int roll = sc.nextInt();
                        String name = sc.next();
                        int marks = sc.nextInt();

                        PreparedStatement ps1 = con.prepareStatement("INSERT INTO Student VALUES(?, ?, ?)");
                        ps1.setInt(1, roll);
                        ps1.setString(2, name);
                        ps1.setInt(3, marks);
                        ps1.executeUpdate();
                        System.out.println("Record Added.");
                        break;

                    case 2: // DISPLAY
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery("SELECT * FROM Student");
                        while (rs.next()) {
                            System.out.println(rs.getInt(1) + " " + rs.getString(2) + " " + rs.getInt(3));
                        }
                        break;

                    case 3: // UPDATE
                        System.out.print("Enter RollNo to update marks: ");
                        roll = sc.nextInt();
                        System.out.print("Enter new Marks: ");
                        marks = sc.nextInt();
                        PreparedStatement ps2 = con.prepareStatement("UPDATE Student SET Marks=? WHERE RollNo=?");
                        ps2.setInt(1, marks);
                        ps2.setInt(2, roll);
                        ps2.executeUpdate();
                        System.out.println("Record Updated.");
                        break;

                    case 4: // DELETE
                        System.out.print("Enter RollNo to delete: ");
                        roll = sc.nextInt();
                        PreparedStatement ps3 = con.prepareStatement("DELETE FROM Student WHERE RollNo=?");
                        ps3.setInt(1, roll);
                        ps3.executeUpdate();
                        System.out.println("Record Deleted.");
                        break;

                    case 5:
                        System.out.println("Exiting...");
                        con.close();
                        return;
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
