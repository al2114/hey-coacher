using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PresentData.App_Code;
using System.Text;

namespace PresentData
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string show1 = "SELECT Person.*, Email, Pwd FROM Person LEFT JOIN Access ON Person.PersonId = Access.PersonId";
            DBMaster dbm = new DBMaster();
            SqlDataReader reader = dbm.getReader(show1);

            StringBuilder tmp = new StringBuilder();
            tmp.Append("<table border = '1'>");
            tmp.Append("<tr><th>PersonId</th><th>FirstName</th><th>LastName</th><th>DoB</th><th>W_kg</th><th>Height_cm</th><th>Notes</th><th>Gender</th><th>Email</th><th>Password</th>");
            tmp.Append("</tr>");
            
            while (reader.Read())
            {
                tmp.Append("<tr>");
                tmp.Append("<td>" + reader["PersonId"] + "</td>");
                tmp.Append("<td>" + reader["FirstName"] + "</td>");
                tmp.Append("<td>" + reader["LastName"] + "</td>");
                tmp.Append("<td>" + reader["DoB"] + "</td>");
                tmp.Append("<td>" + reader["W_kg"] + "</td>");
                tmp.Append("<td>" + reader["Height_cm"] + "</td>");
                tmp.Append("<td>" + reader["Notes"] + "</td>");
                tmp.Append("<td>" + reader["Gender"] + "</td>");
                tmp.Append("<td>" + reader["Email"] + "</td>");
                tmp.Append("<td>" + reader["Pwd"] + "</td>");
                tmp.Append("</tr>");
            }

            tmp.Append("</tmp");

            dbm.closeConnection();

            lbl_test.Controls.Add(new Literal { Text = tmp.ToString() });
        }
    }
}