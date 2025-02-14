# Laravel Application

> Author's NOTES:
> PHP offers great documentation in an evolving ecosystem that has multiple functionalities, albeit dynamiclly typed and interpreted language.
> Regardless of it's stigma and/or limitations the language offers intuitive and strightforeward ways to write code and achieve tasks.
> `Laravel` framework and its ecosystem inherit the latter, making `backend` infrastructure implementation very concice; marking a starting point
> for any idea.
>
> This infrastructure, for now, manages `authentication` (whom is who) as well as serves the application's resources through
> various end-points as a (Json only) `programming application interface` or `API`. The `authrization` logic (whom is served what) is left to the `API`.
> We'll discuss briefly, later on, the adoption of well crafted components for future use and how to adjust for growth on this `API` ecosystem.
>
> The `frontend` managment and logic is left to browser-native technologies (i.e. javascript, html, css).
> Using Node as runtime and NPM to deliver packages; most notably `Vite`, `Vue`, and `Sass`;
> which (at the moment) satisfy most of the frontend needs and should deliver a browser-native "compiled" product [more on that...]().
>
> We'll try to refrain and include as less javascript as possible (or any other language for that matter)
> and include only the necessary packages within their respective package manager configuration file.
> Excempt for a few instructions probably on how to install and use, there should not be that much _mixing_.

## Table of contents

-   [Authentication (thephpleague/oauth2-server)](#authentication-thephpleagueoauth2-server)
    -   [Passport](#passport-laravelpassport)
        -   [Usage remarks](#usage-remarks)
        -   [Passport Vue Components](#passport-vue-components)
-   [Asset Bundling (Vite)](#asset-bundling-vite)
-   [API (laravel-json-api/laravel)]
    -   Notes and discussion

## Authentication ([thephpleague/oauth2-server](https://github.com/thephpleague/oauth2-server))

ThePHPLeague `oauth2-server` provides the infrastructure for the `authentication` stack.
Per their [documentation](https://oauth2.thephpleague.com/), laravel's `Passport` is marked as the official framework implementation.

_All documentation on `password grant` will be ignored and efforts no longer pursued_

`PKCE` is the only implementation being explored by this project, so far. There is enough reason to believe that
there will be need to leverage the whole package further down the line.

Currently speaking of `laravel/passport` yet migration to core`thephpleague/oauth2-server` have not yet been discarded.

\*\* Further research will have to be made on this subject.
Please check (Symphony) [thephpleague/oauth2-server-bundle](https://github.com/thephpleague/oauth2-server-bundle)

PHP Implementation of `PKCE` treated on project is **server only**. `PKCE Client` side is, left for `client` to implement
[proxymurder/vite](https://github.com/proxymurder/vite)

The final solution to the authentication question has yet to be discussed on a broader spectrum,
proposed solutions at the moment are monolithic and conservative, whereas the ideal solution should offer the correct ammounts of freadom,
privacy and security to the average user despite their knowledge on the subject.

\*\* `authentication` being it's own project has yet to be explored.

### Passport ([laravel/passport](https://github.com/laravel/passport))

Install passport keys (only after downloading)

```
php artisan passport:keys
```

Create `Passport Public Client`

```
php artisan passport:client --public
```

Please note `Client ID` value for future reference; no `secret` is provided for this client method.

#### Usage remarks

Project manages both `migrations` and `routes` for `passport`. Passport state is modified in `app/Providers/AppServiceProvider`

```
Passport::ignoreMigratios()
->ignoreRoutes();
```

Concerning database, `Users` and `Clients` are stored with `UUIDs` instead of incrementing integers,
therefore `passport` migrations have been published and are locally available in `database/migrations` directory.

Required routes are registered in `App/Providers/RouteServiceProvider` through `routes/oauth.php` file.

Routes mostly mimic the implementation done by the upstream `passport` repository with minor syntax tweaks which serve no purpose other than to proceed with further testing of the `guard` clause, which at the moment of writing this, rest inconclusive.

However, file registers the routes `/login` as `get` (view) and `post` routes.

-   `get` method serves the `login` view within `resources/views/oauth` directory called `authenticate`.
-   `post` route follows `login` method in `App\Http\Controllers\OAuth\AuthenticationController`.

#### Passport Vue Components

The Vue components are located inside `resources/js/components/login`.

There are two components which will be subject to multiple changes, however for now we have a `login/view` which has no major logic to it
other than provide a view container and handle any `prefersColorScheme` changes and`login/form` which structures and submits data.

Initial DOM from which the javascript takes over is provided by `resources/views/oauth/authenticate.blade`.

```
<!DOCTYPE html>
...
<head>
...
    <meta name="csrf-token" content="{{ csrf_token() }}">
    @vite('resources/js/login.js')
</head>
...
<body id="app">
</body>
</html>
```

The previous code snippet shows only one way to do this.
Since at that point of execution we're still in the domain of PHP, the csrf_token can be passed as a prop,

_TODO:_

```
<!DOCTYPE html>
...
<head>
...
    @vite('resources/js/login.js')
</head>
...
<body id="app">
    <login-view :csrf-token-prop="{{ csrf_token() }}"
</body>
</html>
```

None of the above seem to differ in any way other than semantics but testing has yet to prove that. Yet the ilustrate the broader area
being explored, the questions mainly remain. Is it worth breaking out of blade so quickly or could I have better results in the long run?
Can I never use blade (now that I think about it)? Security issues? Scalability issues?... just to mention a few of the wide area concerns.

### Asset Bundling ([Vite](https://github.com/vitejs/vite))

Inside `vite.config.js` we declare within the plugins the correct js that will be executing this task as well.

```
laravel({
    input: [
        path.resolve(__dirname, "./resources/js/login.js"),
    ],
}),
```
