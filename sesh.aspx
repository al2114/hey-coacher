<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sesh.aspx.cs" Inherits="PresentData.sesh" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sesh</title>
    <meta http-equiv="content-type" content="text/html"; charset="utf-8" />
    <style type="text/css">
        .main {background:yellow; position:fixed; overflow:auto; max-height:500px}
    </style>
</head>
<body>
    <div>
    <h1>smartbikeserver</h1>
    <h2>datadb</h2>
    <form runat ="server">
        <asp:LinkButton ID="LinkButton4" runat="server" PostBackUrl ="~/home.aspx">Home</asp:LinkButton>
        &nbsp;
        <asp:LinkButton ID="LinkButton1" runat="server" PostBackUrl ="~/index.aspx">User Profiles</asp:LinkButton> 
        &nbsp;
        <asp:LinkButton ID="LinkButton5" runat="server" PostBackUrl ="~/sesh.aspx">Sessions</asp:LinkButton>
        &nbsp;
        <asp:LinkButton ID="LinkButton2" runat="server" PostBackUrl ="~/record.aspx">Records</asp:LinkButton>
        &nbsp;
        <asp:LinkButton ID="LinkButton3" runat="server" PostBackUrl ="~/rjp.aspx">Record-Join-User</asp:LinkButton>
    </form>
    <h3>Sessions</h3>
    </div>

    <div class="main">
        <asp:Label ID ="lbl_test" runat ="server"></asp:Label>    
    </div>

</body>
</html>
