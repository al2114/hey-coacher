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
    public partial class profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string show2 = "SELECT * FROM dbo.Record ORDER BY SessionId, Instance";
            DBMaster dbm = new DBMaster();
            SqlDataReader reader = dbm.getReader(show2);

            StringBuilder tmp = new StringBuilder();
            tmp.Append("<table border = '1'>");
            tmp.Append("<tr><th>PersonId</th><th>Instance</th><th>HRate</th><th>Pace</th><th>Distance</th><th>Steps</th><th>Cadence</th>");
            tmp.Append("</tr>");

            while (reader.Read())
            {
                tmp.Append("<tr>");
                tmp.Append("<td>" + reader["SessionId"] + "</td>");
                tmp.Append("<td>" + reader["Instance"] + "</td>");
                tmp.Append("<td>" + reader["HRate"] + "</td>");
                tmp.Append("<td>" + reader["Pace"] + "</td>");
                tmp.Append("<td>" + reader["Distance"] + "</td>");
                tmp.Append("<td>" + reader["Steps"] + "</td>");
                tmp.Append("<td>" + reader["Cadence"] + "</td>");
                tmp.Append("</tr>");
            }

            tmp.Append("</tmp");

            dbm.closeConnection();

            lbl_test.Controls.Add(new Literal { Text = tmp.ToString() });
        }
    }
}