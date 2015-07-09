<cfoutput>

<h1>Users</h1>

#flashMessages("success")#

<p>#linkTo(text="+ Add New User", action="new")#</p>

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th colspan="2"></th>
        </tr>
    </thead>
    <tbody>
        <cfloop query="users">
            <tr>
                <td>#users.name#</td>
                <td>#users.email#</td>
                <td>
                    #linkTo(
                        text="Edit", action="edit", key=users.id,
                        title="Edit #users.name#"
                    )#
                </td>
                <td>
                    #linkTo(
                        text="Delete", action="delete", key=users.id,
                        title="Delete #users.name#",
                        confirm="Are you sure that you want to delete
                            #users.name#?"
                    )#
                </td>
            </tr>
        </cfloop>
    </tbody>
</table>

</cfoutput>