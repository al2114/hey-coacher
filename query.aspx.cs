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
    public partial class query : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            StringBuilder temp = new StringBuilder();
            DBMaster dbm = new DBMaster();

            string request = Request.QueryString["request"];
            // REQUEST FOR ID i.e. CLEARANCE  /////////NOT USED ANYMORE. LOGIN IS USED.
            if (request == "id")
            {
                string fname = Request.QueryString["fname"];
                string lname = Request.QueryString["lname"];
                string show1 = "SELECT PersonId FROM dbo.Person WHERE FirstName = '" + fname + "' AND LastName = '" + lname + "';";
                SqlDataReader reader = dbm.getReader(show1);

                while (reader.Read())
                {
                    temp.Append(reader["PersonId"]);
                }
            }
            //////////// CAN INTEGRATE TO ALL READINGS
            else if (request == "value")
            {
                string reading = Request.QueryString["reading"];
                string sid = Request.QueryString["sid"];
                string show2 = "SELECT A.Instance, CAST(A." + reading + " AS DECIMAL(10,2)) AS HRate FROM Record A INNER JOIN (SELECT SessionId, MAX(Instance) AS MaxReading FROM Record GROUP BY SessionId) B ON A.SessionId = B.SessionId AND A.Instance = B.MaxReading WHERE A.SessionId = " + sid + " AND A." + reading + " IS NOT NULL;";
                SqlDataReader reader = dbm.getReader(show2);

                while (reader.Read())
                {
                    temp.Append(reader["Instance"]);
                    temp.Append(" ");
                    temp.Append(reader["HRate"]);
                }
            }

            // SUM OF ALL READINGS
            else if(request == "endval")
            {
                string reading = Request.QueryString["reading"];
                string sid = Request.QueryString["sid"];
                string all = "SELECT DATEDIFF(second,MIN(Instance),MAX(Instance))/60 AS mins, DATEDIFF(second,MIN(Instance),MAX(Instance))%60 AS secs, CAST((SUM(" + reading + ") / COUNT(" + reading + ")) AS DECIMAL(10,1)) AS average, CAST(MAX(" + reading + ") AS DECIMAL(10,1)) AS highest, CAST(MIN(" + reading + ") AS DECIMAL(10,1)) AS lowest FROM dbo.Record WHERE SessionId = " + sid + "; ";
                SqlDataReader reader = dbm.getReader(all);

                while (reader.Read())
                {
                    temp.Append(reader["mins"]);
                    temp.Append(" ");
                    temp.Append(reader["secs"]);
                    temp.Append(" ");
                    temp.Append(reader["average"]);
                    temp.Append(" ");
                    temp.Append(reader["highest"]);
                    temp.Append(" ");
                    temp.Append(reader["lowest"]);
                }
            }

            //REGISTER NEW USER
            else if (request == "user")
            {
                string fname = Request.QueryString["fname"];
                string lname = Request.QueryString["lname"];
                string email = Request.QueryString["email"];
                string pwd = Request.QueryString["pwd"];

                string insuser = "INSERT INTO dbo.Person (FirstName,LastName) VALUES ('" + fname + "','" + lname + "') SELECT PersonId FROM dbo.Person WHERE FirstName = '" + fname + "' AND LastName = '" + lname + "';";

                SqlDataReader reader = dbm.getReader(insuser);
                temp.Append("Accepted ");
                string id = "";
                while (reader.Read())
                {
                    id = Convert.ToString(reader["PersonId"]);
                    temp.Append(id);
                }
                
                string inlogin = "INSERT INTO dbo.Access (PersonId,Email,Pwd) VALUES (" + id + ",'" + email + "','" + pwd + "');";
                SqlDataReader reader2 = dbm.getReader(inlogin);
            }

            //GET USER DATA
            else if (request == "getuser")
            {
                string id = Request.QueryString["id"];
                string show = "SELECT * FROM dbo.Person WHERE PersonId = " + id + ";";
                SqlDataReader reader = dbm.getReader(show);
                while(reader.Read())
                {
                    temp.Append(reader["PersonId"]);
                    temp.Append(" ");
                    
                    temp.Append(reader["FirstName"]);
                    temp.Append(" ");

                    temp.Append(reader["LastName"]);
                    temp.Append(" ");

                    if (Convert.ToString(reader["DoB"]) == "") { temp.Append("NULL"); }
                    else { temp.Append(reader["DoB"]); }
                    temp.Append(" ");

                    if (Convert.ToString(reader["W_kg"]) == "") { temp.Append("NULL"); }
                    else { temp.Append(reader["W_kg"]); }
                    temp.Append(" ");

                    if (Convert.ToString(reader["Height_cm"]) == "") { temp.Append("NULL"); }
                    else { temp.Append(reader["Height_cm"]); }
                    temp.Append(" ");

                    if (Convert.ToString(reader["Notes"]) == "") { temp.Append("NULL"); }
                    else { temp.Append(reader["Notes"]); }
                    temp.Append(" ");

                    if (Convert.ToString(reader["Gender"]) == "") { temp.Append("NULL"); }
                    else { temp.Append(reader["Gender"]); }
                }
            }

            //UPDATE USER DATA
            else if (request == "update")
            {
                string id = Request.QueryString["id"];
                
                string DoB = Request.QueryString["dob"];
                if (DoB == "")
                {
                    DoB = "NULL";
                }
                else
                {
                    string builds = "'" + DoB + "'";
                    DoB = builds;
                }

                string wkg = Request.QueryString["weight"];
                if (wkg == "")
                {
                    wkg = "NULL";
                }
                string hcm = Request.QueryString["height"];
                if (hcm == "")
                {
                    hcm = "NULL";
                }

                string notes = Request.QueryString["notes"];
                if (notes == "")
                {
                    notes = "NULL";
                }
                else
                {
                    string builds = "'" + notes + "'";
                    notes = builds;
                }

                string gender = Request.QueryString["gender"];
                if (gender == "")
                {
                    gender = "NULL";
                }
                else
                {
                    string builds = "'" + gender + "'";
                    gender = builds;
                }

                string update = "UPDATE dbo.Person SET DoB = " + DoB + ", W_kg = " + wkg + ", Height_cm = " + hcm + ", Notes = " + notes + ", Gender = " + gender + " WHERE PersonId = " + id + ";";

                SqlDataReader reader = dbm.getReader(update);
                temp.Append("Accepted");
            }

            //Login
            else if (request == "login")
            {
                string email = Request.QueryString["email"];
                string pwd = Request.QueryString["pwd"];

                string login = "SELECT Person.PersonId, FirstName, Pwd FROM dbo.Person JOIN dbo.Access ON Person.PersonId = Access.PersonId WHERE Email = '" + email + "';";
                SqlDataReader reader = dbm.getReader(login);
                string id = "";
                string pass = "";
                string fname = "";
                while (reader.Read())
                {
                    id = Convert.ToString(reader["PersonId"]);
                    fname = Convert.ToString(reader["FirstName"]);
                    pass = Convert.ToString(reader["Pwd"]);
                }
                if (pwd == pass)
                {
                    temp.Append("Authorised ");
                    temp.Append(id);
                    temp.Append(" ");
                    temp.Append(fname);
                }
                else
                {
                    temp.Append("Unauthorised");
                }
            }

            //NEW SESSION
            else if (request == "startsession")
            {
                string id = Request.QueryString["id"];
                string cls = Request.QueryString["class"];
                string date = Convert.ToString(DateTime.Now);
                string show = "INSERT INTO dbo.Sesh (PersonId,Class,Status,Date) VALUES (" + id + ",'" + cls + "','Active','" + date + "') SELECT SessionId FROM dbo.Sesh WHERE Status = 'Active' AND PersonId = " + id + " AND Class = '" + cls + "';";
                SqlDataReader reader = dbm.getReader(show);
                string sid = "";
                while (reader.Read())
                {
                    sid = Convert.ToString(reader["SessionId"]);
                    temp.Append(sid);
                }
                dbm.closeConnection();
                string now = "'" + Convert.ToString(DateTime.Now.Hour) + ":" + Convert.ToString(DateTime.Now.Minute) + ":" + Convert.ToString(DateTime.Now.Second) + "'";
                string show2 = "INSERT INTO dbo.Record (SessionId,Instance) VALUES (" + sid + "," + now + ")";
                SqlDataReader reader2 = dbm.getReader(show2);
                dbm.closeConnection();

                if (cls == "biking" && Convert.ToInt32(id) == 41)
                {
                    string insertdata = "INSERT INTO [dbo].[Record] ([SessionId],[Instance],[HRate],[Pace],[Distance]) VALUES (" + sid + ",'0:0:0',124,0,0),(" + sid + ",'0:0:45',125,3.75,0.2),(" + sid + ",'0:1:29',126,3.70833333333333,0.4),(" + sid + ",'0:2:11',128,3.63888888888889,0.6)";
                    SqlDataReader datareader = dbm.getReader(insertdata);
                    dbm.closeConnection();
                }
            }

            //END SESSION
            else if (request == "endsession")
            {
                string sid = Request.QueryString["sid"];
                string now = "'" + Convert.ToString(DateTime.Now.Hour) + ":" + Convert.ToString(DateTime.Now.Minute) + ":" + Convert.ToString(DateTime.Now.Second) + "'";
                string show2 = "INSERT INTO dbo.Record (SessionId,Instance) VALUES (" + sid + "," + now + ")";
                SqlDataReader reader2 = dbm.getReader(show2);
                dbm.closeConnection();

                string show1 = "UPDATE dbo.Sesh SET Mins = (SELECT COALESCE(DATEDIFF(second,MIN(Instance),MAX(Instance))/60,0) FROM Record WHERE SessionId = " + sid + ") ,Secs = (SELECT COALESCE(DATEDIFF(second,MIN(Instance),MAX(Instance))%60,0) FROM Record WHERE SessionId = " + sid + ") ,AveragePace = (SELECT COALESCE(A.Pace,0) AS Pace FROM Record A INNER JOIN (SELECT SessionId, MAX(Instance) AS MaxReading FROM Record GROUP BY SessionId) B ON A.SessionId = B.SessionId AND A.Instance = B.MaxReading WHERE A.SessionId = " + sid + " AND A.Pace IS NOT NULL) ,MaxPace = (SELECT COALESCE(MAX(Pace),0) FROM Record WHERE SessionId = " + sid + ") ,MinPace = (SELECT COALESCE(MIN(Pace),0) FROM Record WHERE SessionId = " + sid + " AND Pace != 0) ,AverageHR = (SELECT COALESCE((SUM(HRate)/COUNT(HRate)),0) FROM Record WHERE SessionId = " + sid + " AND HRate IS NOT NULL) ,MaxHR = (SELECT COALESCE(MAX(HRate),0) FROM Record WHERE SessionId = " + sid + ") ,MinHR = (SELECT COALESCE(MIN(HRate),0) FROM Record WHERE SessionId = " + sid + ") ,Status = NULL WHERE SessionId = " + sid + ";";
                SqlDataReader reader = dbm.getReader(show1);
                dbm.closeConnection();

                string getTime = "SELECT PersonId,Mins,Secs FROM dbo.Sesh WHERE SessionId = " + sid + ";";
                SqlDataReader reader3 = dbm.getReader(getTime);
                int mins = 0;
                int secs = 0;
                int pid = 0;
                while (reader3.Read())
                {
                    mins = Convert.ToInt32(reader3["Mins"]);
                    secs = Convert.ToInt32(reader3["Secs"]);
                    pid = Convert.ToInt32(reader3["PersonId"]);
                }
                dbm.closeConnection();
                if ((mins == 0) || ((mins == 1) && (secs == 0)))
                {
                    string del1 = "DELETE FROM dbo.Sesh WHERE SessionId = " + sid + ";";
                    string del2 = "DELETE FROM dbo.Record WHERE SessionId = " + sid + ";";
                    SqlDataReader r1 = dbm.getReader(del2);
                    dbm.closeConnection();
                    SqlDataReader r2 = dbm.getReader(del1);
                    dbm.closeConnection();
                    temp.Append("Session Discarded");
                }
                else
                {
                    temp.Append("Session Ended");
                    string del = "DELETE FROM dbo.Record WHERE SessionId = " + sid + " AND HRate IS NULL AND Pace IS NULL AND Distance IS NULL AND Steps IS NULL AND Cadence IS NULL";
                    SqlDataReader delentries = dbm.getReader(del);
                    dbm.closeConnection();

                    if (pid == 41 || pid == 34)
                    {
                        string del1 = "DELETE FROM dbo.Sesh WHERE SessionId = " + sid + ";";
                        string del2 = "DELETE FROM dbo.Record WHERE SessionId = " + sid + ";";
                        SqlDataReader r1 = dbm.getReader(del2);
                        dbm.closeConnection();
                        SqlDataReader r2 = dbm.getReader(del1);
                        dbm.closeConnection();
                    }

                }

                reader = dbm.getReader(show1);
            }


            //ADD NEW DATA
            else if (request == "data")
            {
                string sid = Request.QueryString["sid"];
                string inst = Request.QueryString["instance"];
                if (inst == "")
                {
                    inst = "0";
                }
                int time = Convert.ToInt32(inst);
                int seconds = time % 60;
                int minutes = time / 60;
                int hours = 0;
                if (minutes >= 60)
                {
                    hours = minutes / 60;
                    minutes = minutes % 60;
                }
                inst = Convert.ToString(hours) + ":" + Convert.ToString(minutes) + ":" + Convert.ToString(seconds); 

                string hr = Request.QueryString["hr"];
                if (hr == "")
                {
                    hr = "NULL";
                }
                string cadence = Request.QueryString["cadence"];
                if (cadence == "")
                {
                    cadence = "NULL";
                }
                string dist = Request.QueryString["dist"];
                if (dist == "")
                {
                    dist = "NULL";
                }
                string pace = Request.QueryString["pace"];
                if (pace == "")
                {
                    pace = "NULL";
                }
                string steps = Request.QueryString["steps"];
                if (steps == "")
                {
                    steps = "NULL";
                }
                string show = "INSERT INTO dbo.Record (SessionId,Instance,HRate,Pace,Distance,Steps,Cadence) VALUES (" + sid + ",'" + inst + "'," + hr + "," + pace + "," + dist + "," + steps + "," + cadence + ");";

                SqlDataReader reader = dbm.getReader(show);
                dbm.closeConnection();

                temp.Append("Accepted");
            }

            // GET PROGRESS / MOTIVATION
            else if (request == "progress")
            {
                string sid = Request.QueryString["sid"];
                string pid = Request.QueryString["pid"];

                decimal CurrentPace = 0;
                decimal AverageOverallPace = 0;
                decimal AverageRelativePace = 0;
                string DistanceTravelled = "";
                string cls = "";

                string getcls = "SELECT Class FROM Sesh WHERE SessionId = " + sid + ";";
                SqlDataReader classreader = dbm.getReader(getcls);
                while (classreader.Read())
                {
                    cls = Convert.ToString(classreader["Class"]);
                }
                dbm.closeConnection();

                string getcurrentpace = "SELECT A.Pace AS Pace, A.Distance AS Distance FROM Record A INNER JOIN (SELECT SessionId, MAX(Instance) AS MaxReading FROM Record WHERE Pace IS NOT NULL GROUP BY SessionId) B ON A.SessionId = B.SessionId AND A.Instance = B.MaxReading WHERE A.SessionId = " + sid + ";";
                SqlDataReader currentpacereader = dbm.getReader(getcurrentpace);
                while (currentpacereader.Read())
                {
                    CurrentPace = Convert.ToDecimal(currentpacereader["Pace"]);
                    DistanceTravelled = Convert.ToString(currentpacereader["Distance"]);
                }
                dbm.closeConnection();

                string getoverallpace = "SELECT (SUM(AveragePace)/COUNT(AveragePace)) AS Average FROM Sesh JOIN (SELECT TOP 5 SessionId FROM Sesh WHERE PersonId = " + pid + " AND SessionId != " + sid + " AND Class = '" + cls + "' ORDER BY SessionId DESC) A ON Sesh.SessionId = A.SessionId;";
                SqlDataReader overallaveragereader = dbm.getReader(getoverallpace);
                while (overallaveragereader.Read())
                {
                    AverageOverallPace = Convert.ToDecimal(overallaveragereader["Average"]);
                }
                dbm.closeConnection();

                string getrelativepace = "SELECT (SUM(A.Pace)/COUNT(A.Pace)) AS Average FROM (SELECT TOP 5 Sesh.SessionId, Distance, Pace FROM Sesh JOIN Record ON Sesh.SessionId = Record.SessionId WHERE PersonId = " + pid + " AND Class = '" + cls + "' AND Sesh.SessionId != " + sid + " AND Distance = " + DistanceTravelled + " ORDER BY Sesh.SessionId DESC) A;";
                SqlDataReader relativepacereader = dbm.getReader(getrelativepace);
                while (relativepacereader.Read())
                {
                    AverageRelativePace = Convert.ToDecimal(relativepacereader["Average"]);
                }
                dbm.closeConnection();

                decimal LowerBound = Decimal.Multiply(AverageOverallPace, 1.05M);
                decimal UpperBound = Decimal.Multiply(AverageRelativePace, 0.89M);

                string output = "";
                //output = "lb = " + Convert.ToString(LowerBound) + ", Class = " + cls + ", Current Pace = " + Convert.ToString(CurrentPace) + ", Average Overall Pace = " + Convert.ToString(AverageOverallPace) + ", Average Relative Pace = " + Convert.ToString(AverageRelativePace) + ", Distance Travelled = " + DistanceTravelled + System.Environment.NewLine;

                if (CurrentPace > LowerBound)
                {
                    output += "{ \"analysis\":\"You’re going slower than your average pace\", \"motivation\":\"Keep pushing! You can do better!\" }";
                    if (Convert.ToInt32(pid) == 41)
                    {
                        string insertdata = "INSERT INTO [dbo].[Record] ([SessionId],[Instance],[HRate],[Pace],[Distance]) VALUES (" + sid + ",'0:2:49',130,3.52083333333333,0.8),(" + sid + ",'0:3:25',130,3.41666666666667,1),(" + sid + ",'0:3:59',130,3.31944444444444,1.2),(" + sid + ",'0:4:30',130,3.21428571428571,1.4),(" + sid + ",'0:4:59',130,3.11458333333333,1.6),(" + sid + ",'0:5:25',131,3.00925925925926,1.8),(" + sid + ",'0:5:51',135,2.925,2),(" + sid + ",'0:6:19',139,2.87121212121212,2.2)";
                        SqlDataReader datareader = dbm.getReader(insertdata);
                        dbm.closeConnection();
                    }
                }
                else if (CurrentPace > AverageOverallPace)
                {
                    output += "{ \"analysis\":\"You're just below your average pace\", \"motivation\":\"Pace up a bit. Keep going!\" }";
                    if (Convert.ToInt32(pid) == 41)
                    {
                        string insertdata = "INSERT INTO [dbo].[Record] ([SessionId],[Instance],[HRate],[Pace],[Distance]) VALUES (" + sid + ",'0:13:38',135,3.40833333333333,4),(" + sid + ",'0:14:10',135,3.37301587301587,4.2),(" + sid + ",'0:14:38',139,3.32575757575758,4.4),(" + sid + ",'0:15:4',134,3.27536231884058,4.6),(" + sid + ",'0:15:42',128,3.27083333333333,4.8),(" + sid + ",'0:16:28',123,3.29333333333333,5)";
                        SqlDataReader datareader = dbm.getReader(insertdata);
                        dbm.closeConnection();
                    }
                }
                else if (CurrentPace < UpperBound)
                {
                    output += "{ \"analysis\":\"You're going too fast\", \"motivation\":\"Pace down a bit otherwise you will get tired soon\" } ";
                    if (Convert.ToInt32(pid) == 41)
                    {
                        string insertdata = "INSERT INTO [dbo].[Record] ([SessionId],[Instance],[HRate],[Pace],[Distance]) VALUES (" + sid + ",'0:6:57',141,2.89583333333333,2.4),(" + sid + ",'0:7:40',142,2.94871794871795,2.6),(" + sid + ",'0:8:28',145,3.02380952380952,2.8),(" + sid + ",'0:9:20',141,3.11111111111111,3),(" + sid + ",'0:10:18',140,3.21875,3.2),(" + sid + ",'0:11:20',135,3.33333333333333,3.4),(" + sid + ",'0:12:15',136,3.40277777777778,3.6),(" + sid + ",'0:13:0',135,3.42105263157895,3.8)";
                        SqlDataReader datareader = dbm.getReader(insertdata);
                        dbm.closeConnection();
                    }
                }
                else
                {
                    output += "{ \"analysis\":\"Your pace is well within the average\", \"motivation\":\"Keep up the good work!\" }";
                }
                
                temp.Append(output);
            }
            
            // Compare with previous sessions
            else if (request == "previous")
            {
                string id = Request.QueryString["pid"];
                string sid = Request.QueryString["sid"];
                string info = "SELECT Class, Mins, Secs, CAST(AveragePace AS DECIMAL (10,2)) AS AveragePace, CAST(COALESCE(Dist,0) AS DECIMAL (10,1)) AS Dist FROM Sesh JOIN (SELECT SessionId, MAX(Distance) AS Dist FROM Record GROUP BY SessionId) B ON Sesh.SessionId = B.SessionId WHERE Sesh.SessionId = " + sid + " AND Sesh.PersonId = " + id + ";";
                SqlDataReader getinfo = dbm.getReader(info);
                string cls = "";
                string mins = "";
                string secs = "";
                string AveragePace = "";
                string Dist = "";
            
                while (getinfo.Read())
                {
                    cls = Convert.ToString(getinfo["Class"]);
                    mins = Convert.ToString(getinfo["Mins"]);
                    secs = Convert.ToString(getinfo["Secs"]);
                    AveragePace = Convert.ToString(getinfo["AveragePace"]);
                    Dist = Convert.ToString(getinfo["Dist"]);
                }
                dbm.closeConnection();

                string q1 = ""; string q2 = ""; string q3 = ""; string q4 = "";

                string getq1 = "SELECT CAST(DATEDIFF(second,'00:00:00',instance)/(60*1.2) AS DECIMAL (10,2)) AS p1 FROM Record WHERE SessionId = " + sid + " AND Distance = 1.2";
                SqlDataReader q1reader = dbm.getReader(getq1);
                while (q1reader.Read())
                {
                    q1 = Convert.ToString(q1reader["p1"]);
                }
                dbm.closeConnection();
                string getq2 = "SELECT CAST(DATEDIFF(second,A.t1,instance)/(60*1.2) AS DECIMAL (10,2)) AS p2 FROM Record JOIN (SELECT SessionId, Instance AS t1 FROM Record WHERE Distance = 1.2) A ON Record.SessionId = A.SessionId WHERE Distance = 2.4 AND Record.SessionId = " + sid + ";";
                SqlDataReader q2reader = dbm.getReader(getq2);
                while (q2reader.Read())
                {
                    q2 = Convert.ToString(q2reader["p2"]);
                }
                dbm.closeConnection();
                string getq3 = "SELECT CAST(DATEDIFF(second,A.t1,instance)/(60*1.4) AS DECIMAL (10,2)) AS p3 FROM Record JOIN (SELECT SessionId, Instance AS t1 FROM Record WHERE Distance = 2.4) A ON Record.SessionId = A.SessionId WHERE Distance = 3.8 AND Record.SessionId = " + sid + ";";
                SqlDataReader q3reader = dbm.getReader(getq3);
                while (q3reader.Read())
                {
                    q3 = Convert.ToString(q3reader["p3"]);
                }
                dbm.closeConnection();
                string getq4 = "SELECT CAST(DATEDIFF(second,A.t1,instance)/(60*1.2) AS DECIMAL (10,2)) AS p4 FROM Record JOIN (SELECT SessionId, Instance AS t1 FROM Record WHERE Distance = 3.8) A ON Record.SessionId = A.SessionId WHERE Distance = 5 AND Record.SessionId = " + sid + ";";
                SqlDataReader q4reader = dbm.getReader(getq4);
                while (q4reader.Read())
                {
                    q4 = Convert.ToString(q4reader["p4"]);
                }
                dbm.closeConnection();
                string type = "faster";
                decimal CurrentPace = Convert.ToDecimal(AveragePace);
                decimal comp = 0;
                decimal AverageOverallPace = 0;
                string count = "";
                string getoverallpace = "SELECT COALESCE(SUM(AveragePace)/COUNT(AveragePace),0) AS Average, COUNT(AveragePace) AS num FROM Sesh JOIN (SELECT TOP 5 SessionId FROM Sesh WHERE PersonId = " + id + " AND SessionId < " + sid + " AND Class = '" + cls + "' ORDER BY SessionId DESC) A ON Sesh.SessionId = A.SessionId;";
                SqlDataReader overallaveragereader = dbm.getReader(getoverallpace);
                while (overallaveragereader.Read())
                {
                    AverageOverallPace = Convert.ToDecimal(overallaveragereader["Average"]);
                    count = Convert.ToString(overallaveragereader["num"]);
                }
                if(AverageOverallPace == 0)
                {
                    comp = 0;
                }
                else if(AverageOverallPace < CurrentPace)
                {
                    type = "slower";
                    comp = (CurrentPace - AverageOverallPace) * 60;
                    comp = comp * (-1);
                }
                else
                {
                    comp = (AverageOverallPace - CurrentPace) * 60;
                }
                dbm.closeConnection();
                q1 = string.IsNullOrEmpty(q1) ? "0.00" : q1;
                q2 = string.IsNullOrEmpty(q2) ? "0.00" : q2;
                q3 = string.IsNullOrEmpty(q3) ? "0.00" : q3;
                q4 = string.IsNullOrEmpty(q4) ? "0.00" : q4;

                string output = "{ \"class\":\"" + cls + "\", \"minutes\":" + mins + ", \"seconds\":" + secs + ", \"distance\":" + Dist + ", \"averagepace\":" + AveragePace + ", \"q1\":" + q1 + ", \"q2\":" + q2 + ", \"q3\":" + q3 + ", \"q4\":" + q4 + ", \"comparison\":" + comp.ToString("0.##") + ", \"count\":" + count + " }";

                temp.Append(output);
            }

            // Get all Sessions
            else if (request == "sessions")
            {
                string pid = Request.QueryString["pid"];
                string getsessions = "SELECT SessionId, Date, Class, Time FROM dbo.Sesh WHERE PersonId = " + pid + " ORDER BY SessionId DESC";
                SqlDataReader sessionsreader = dbm.getReader(getsessions);
                string output = "[ ";
                int k = 0;
                while (sessionsreader.Read())
                {
                    if (k == 1) { output += ", "; }
                    output += "{ \"sid\":";
                    output += Convert.ToString(sessionsreader["SessionId"]);
                    output += ", \"date\":\"";
                    DateTime date = Convert.ToDateTime(sessionsreader["Date"]);
                    output += date.DayOfWeek;
                    output += " ";
                    output += Convert.ToString(date.ToShortDateString());
                    output += "\", \"time\":\"";
                    output += Convert.ToString(date.ToShortTimeString());
                    output += "\", \"class\":\"";
                    output += Convert.ToString(sessionsreader["Class"]);
                    output += "\" }";
                    k = 1;
                }
                dbm.closeConnection();
                output += " ]";
                temp.Append(output);
            }

            else
            {
                temp.Append("***************************");
                temp.Append("</br>");
                temp.Append("*******BAD REQUEST*******");
                temp.Append("</br>");
                temp.Append("***************************");
            }

            dbm.closeConnection();

            lbl_test.Controls.Add(new Literal { Text = temp.ToString() });
        }
    }
}