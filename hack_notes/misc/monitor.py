import requests

# Open the file and read the lines
with open('users.txt', 'r') as file:
    # Read lines from the file
    for line in file:
        # Remove leading and trailing whitespaces
        line = line.strip()
        
        # Split the line into email and session cookie using the ':' delimiter
        email, session_cookie = line.split(':')

        # The URL you want to fetch
        url = 'https://partners.shopify.com/signup/user'

        # Setting up the cookies for each session
        cookies = {
            '_partners_session': session_cookie
        }

        # Send a GET request with the cookies
        response = requests.get(url, cookies=cookies)

        # Check if the request was successful
        if response.status_code == 200:
            data = response.json()  # Convert the response to JSON
            pending_invitations = data.get('pendingInvitations', [])

            if pending_invitations:
                print(f"There are pending invitations for {email} (session: {session_cookie}):")
                # Uncomment these lines to display the details
                # for invitation in pending_invitations:
                #     print(f"Organization: {invitation['organizationName']}, Inviter: {invitation['inviterEmail']}")
                #     print(f"Accept Invitation Link: {invitation['acceptInvitationPath']}")
            else:
                print(f"No pending invitations for {email} (session: {session_cookie}).")
        else:
            print(f"Error with session for {email} (session: {session_cookie}): {response.status_code} Please update it.")

    print("Monitoring Accounts ...")
    while True:
        file.seek(0)
        for line2 in file:
                # Remove leading and trailing whitespaces
                line2 = line2.strip()
                
                # Split the line into email and session cookie using the ':' delimiter
                email, session_cookie = line2.split(':')

                # The URL you want to fetch
                url = 'https://partners.shopify.com/signup/user'

                # Setting up the cookies for each session
                cookies = {
                    '_partners_session': session_cookie
                }

                # Send a GET request with the cookies
                response = requests.get(url, cookies=cookies)

                # Check if the request was successful
                if response.status_code == 200:
                    data = response.json()  # Convert the response to JSON
                    pending_invitations = data.get('pendingInvitations', [])

                    if pending_invitations:
                        print(f"There are pending invitations for {email} (session: {session_cookie}):")
                        # Uncomment these lines to display the details
                        # for invitation in pending_invitations:
                        #     print(f"Organization: {invitation['organizationName']}, Inviter: {invitation['inviterEmail']}")
                        #     print(f"Accept Invitation Link: {invitation['acceptInvitationPath']}")
                    
                else:
                    print(f"Error with session for {email} (session: {session_cookie}): {response.status_code} Please update it.")
