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
    public partial class sesh : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string show = "SELECT * FROM dbo.Sesh";
            DBMaster dbm = new DBMaster();
            SqlDataReader reader = dbm.getReader(show);

            StringBuilder tmp = new StringBuilder();
            tmp.Append("<table border = '1'>");
            tmp.Append("<tr><th>SessionId</th><th>PersonId</th><th>Class</th><th>Mins</th><th>Secs</th><th>AveragePace</th><th>MaxPace</th><th>MinPace</th><th>AverageHR</th><th>MaxHR</th><th>MinHR</th><th>Date</th><th>Status</th>");
            tmp.Append("</tr>");

            while (reader.Read())
            {
                tmp.Append("<tr>");
                tmp.Append("<td>" + reader["SessionId"] + "</td>");
                tmp.Append("<td>" + reader["PersonId"] + "</td>");
                tmp.Append("<td>" + reader["Class"] + "</td>");
                tmp.Append("<td>" + reader["Mins"] + "</td>");
                tmp.Append("<td>" + reader["Secs"] + "</td>");
                tmp.Append("<td>" + reader["AveragePace"] + "</td>");
                tmp.Append("<td>" + reader["MaxPace"] + "</td>");
                tmp.Append("<td>" + reader["MinPace"] + "</td>");
                tmp.Append("<td>" + reader["AverageHR"] + "</td>");
                tmp.Append("<td>" + reader["MaxHR"] + "</td>");
                tmp.Append("<td>" + reader["MinHR"] + "</td>");
                tmp.Append("<td>" + reader["Date"] + "</td>");
                tmp.Append("<td>" + reader["Status"] + "</td>");
                tmp.Append("</tr>");
            }

            tmp.Append("</tmp");

            dbm.closeConnection();

            lbl_test.Controls.Add(new Literal { Text = tmp.ToString() });
        }
    }
}