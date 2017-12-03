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
    public partial class rjp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string show3 = "SELECT Person.PersonId, FirstName, LastName, COUNT(Sesh.SessionId) AS Sessions, COALESCE(SUM(Readings),0) AS Readings FROM Sesh LEFT JOIN (SELECT SessionId, COUNT(SessionId) AS Readings FROM Record GROUP BY SessionId) A ON Sesh.SessionId = A.SessionId RIGHT JOIN Person ON Person.PersonId = Sesh.PersonId GROUP BY Person.PersonId, FirstName, LastName";
            DBMaster dbm = new DBMaster();
            SqlDataReader reader = dbm.getReader(show3);

            StringBuilder tmp = new StringBuilder();
            tmp.Append("<table border = '1'>");
            tmp.Append("<tr><th>PersonId</th><th>FirstName</th><th>LastName</th><th>Sessions</th><th>Readings</th>");
            tmp.Append("</tr>");

            while (reader.Read())
            {
                tmp.Append("<tr>");
                tmp.Append("<td>" + reader["PersonId"] + "</td>");
                tmp.Append("<td>" + reader["FirstName"] + "</td>");
                tmp.Append("<td>" + reader["LastName"] + "</td>");
                tmp.Append("<td>" + reader["Sessions"] + "</td>");
                tmp.Append("<td>" + reader["Readings"] + "</td>");
                tmp.Append("</tr>");
            }

            tmp.Append("</tmp");

            dbm.closeConnection();

            lbl_test.Controls.Add(new Literal { Text = tmp.ToString() });
        }
    }
}