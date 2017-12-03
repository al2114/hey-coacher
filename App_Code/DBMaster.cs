using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace PresentData.App_Code
{
    public class DBMaster
    {
        private SqlConnection conn;
        public SqlConnection getConnnection()
        {
            //Connect to DB
            string connStr = "Server=smartbikeserver.database.windows.net;Database=datadb;User Id=devin; Password=pwd@1234";
            conn = new SqlConnection(connStr);
            conn.Open();
            return conn;
        }
        public SqlDataReader getReader(string query)
        {
            // Create a command
            SqlCommand cmd = new SqlCommand(query);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Connection = this.getConnnection();

            // Read from DB
            SqlDataReader reader = cmd.ExecuteReader();
            return reader;
        }
        public void closeConnection()
        {
            if(conn != null && conn.State == System.Data.ConnectionState.Open)
            {
                this.conn.Close();
            }
        }
    }
}