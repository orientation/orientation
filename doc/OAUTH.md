# OAuth

Orientation uses Google OAuth to identify users in order to avoid creating a new set of credentials for people on your team.

This is an example of the oauth_hash returned by OmniAuth after a user selects a Google account:

```ruby
#<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1392626015 token="ya29.1.AADtN_W09iRc601tMBjy7zo1Hk0Gj2DJrYrYkdm2E6Xy-zcvqTBNF0B5A4QtwvWMLg"> extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash email="olivier@envylabs.com" family_name="Lacan" gender="male" given_name="Olivier" hd="envylabs.com" id="114578626957291250398" link="https://plus.google.com/114578626957291250398" locale="en" name="Olivier Lacan" picture="https://lh3.googleusercontent.com/-27lKwTkFt5c/AAAAAAAAAAI/AAAAAAAAAB0/qdUbfasX9AA/s40-c/photo.jpg" verified_email=true>> info=#<OmniAuth::AuthHash::InfoHash email="olivier@envylabs.com" first_name="Olivier" image="https://lh3.googleusercontent.com/-27lKwTkFt5c/AAAAAAAAAAI/AAAAAAAAAB0/qdUbfasX9AA/s40-c/photo.jpg" last_name="Lacan" name="Olivier Lacan" urls=#<OmniAuth::AuthHash Google="https://plus.google.com/114578626957291250398">> provider="google_oauth2" uid="114578626957291250398">
```