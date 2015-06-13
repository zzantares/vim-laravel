" laravel.vim - A set of helpers for Laravel projects.
" Author: César Antáres <zzantares@gmail.com>

" Does not work if user does not have PHP
if (!executable('php'))
    finish
endif

" ifndef ... define
" if exists('g:loaded_laravel')
"     finish
" endif
" 
" let g:loaded_laravel = 1

" Options
" Si no existe un recurso lo crea
if !exists('g:laravel_vim_create_if_not_exists')
    " Values are: 'notify', 'ask', 'empty', 'artisan'
    let g:laravel_vim_create_if_not_exists = 'artisan'
endif


" Receives a command to execute as an external command
function! s:executor(param)
    silent !clear
    let l:command = 'php artisan ' . a:param . ' --no-interaction'
    execute 'silent !' . l:command
    redraw!
    echo l:command
endfunction

" Helper for :Acommand functions
function! s:artisan(command, ...)
    let l:command = a:command . ' ' . join(a:1)
    call s:executor(l:command)
endfunction

function! s:boot()
    let on_track = len(findfile('artisan', getcwd()))

    if (!on_track)
        echo 'Can not find artisan, be sure to be inside the project folder.'
        finish
    endif
endfunction

function! s:file_exists(file)
    if !empty(glob(a:file))
        return 1
    endif
endfunction

function! s:laravel_executor(command)
    silent !clear
    execute a:command
    redraw!
    echo a:command
endfunction


" Artisan wrapper
function! Artisan(command, ...)
    let l:command = a:command . ' ' . join(a:000)
    call s:executor(l:command)
endfunction


" Helper functions sub-artisan wrappers
function! ArtisanApp(action, ...)
    call s:artisan('app:' . a:action, a:000)
endfunction

function! ArtisanAuth(action, ...)
    call s:artisan('auth:' . a:action, a:000)
endfunction

function! ArtisanCache(action, ...)
    call s:artisan('cache:' . a:action, a:000)
endfunction

function! ArtisanConfig(action, ...)
    call s:artisan('config:' . a:action, a:000)
endfunction

function! ArtisanDb(action, ...)
    call s:artisan('db:' . a:action, a:000)
endfunction

function! ArtisanEvent(action, ...)
    call s:artisan('event:' . a:action, a:000)
endfunction

function! ArtisanHandler(action, ...)
    call s:artisan('handler:' . a:action, a:000)
endfunction

function! ArtisanKey(action, ...)
    call s:artisan('key:' . a:action, a:000)
endfunction

function! ArtisanMake(resource, ...)
    call s:artisan('make:' . a:resource, a:000)
endfunction

function! ArtisanMigrate(action, ...)
    call s:artisan('migrate:' . a:action, a:000)
endfunction

function! ArtisanQueue(action, ...)
    call s:artisan('queue:' . a:action, a:000)
endfunction

function! ArtisanRoute(action, ...)
    call s:artisan('route:' . a:action, a:000)
endfunction

function! ArtisanSchedule(action, ...)
    call s:artisan('schedule' . a:action, a:000)
endfunction

function! ArtisanSession(action, ...)
    call s:artisan('session:' . a:action, a:000)
endfunction

function! ArtisanVendor(action, ...)
    call s:artisan('vendor:' . a:action, a:000)
endfunction


" Open file helpers
function! LaravelController(controller, ...)
    call s:boot()
    let command = 'app/Http/Controllers/' . a:controller . 'Controller.php'

    " Open if exists
    if s:file_exists(command)
        call s:laravel_executor('e ' . command)

    " Make a choice if not exists
    else
        if (g:laravel_vim_create_if_not_exists == 'notify')
            echo command 'does not exist.'

        elseif (g:laravel_vim_create_if_not_exists == 'ask')
            let choice = input(command . ' does not exist, (m)ake, (e)mpty, (c)ancel?: ')

            if choice == 'm' || choice == 'make'
                call ArtisanMake('controller', a:controller . 'Controller ' . join(a:000))
                call s:laravel_executor('e ' . command)
            elseif choice == 'e' || choice == 'empty'
                call s:laravel_executor('e ' . command)
            else
                echo "\nOperation cancelled."
            endif

        elseif (g:laravel_vim_create_if_not_exists == 'empty')
            call s:laravel_executor('e ' . command)

        elseif (g:laravel_vim_create_if_not_exists == 'artisan')
            call ArtisanMake('controller', a:controller,  . 'Controller ' . join(a:000))
            call s:laravel_executor('e ' . command)
        endif
    endif
endfunction

function! LaravelModel(model)
    call s:boot()
    let command = 'app/' . a:model . '.php'

    " Open if exists
    if s:file_exists(command)
        call s:laravel_executor('e ' . command)

    " Make a choice if not exists
    else
        if (g:laravel_vim_create_if_not_exists == 'notify')
            echo command 'does not exist.'

        elseif (g:laravel_vim_create_if_not_exists == 'ask')
            let choice = input(command . ' does not exist, (m)ake, (e)mpty, (c)ancel?: ')

            if choice == 'm' || choice == 'make'
                call ArtisanMake('model', a:model)
                call s:laravel_executor('e ' . command)
            elseif choice == 'e' || choice == 'empty'
                call s:laravel_executor('e ' . command)
            else
                echo "\nOperation cancelled."
            endif

        elseif (g:laravel_vim_create_if_not_exists == 'empty')
            call s:laravel_executor('e ' . command)

        elseif (g:laravel_vim_create_if_not_exists == 'artisan')
            call ArtisanMake('model', a:model)
            call s:laravel_executor('e ' . command)
        endif
    endif

endfunction

function! LaravelCommand(command)
    call s:boot()
    let command = 'app/Commands/' . a:command . '.php'

    " Open if exists
    if s:file_exists(command)
        call s:laravel_executor('e ' . command)

    " Make a choice if not exists
    else
        if (g:laravel_vim_create_if_not_exists == 'notify')
            echo command 'does not exist.'

        elseif (g:laravel_vim_create_if_not_exists == 'ask')
            let choice = input(command . ' does not exist, (m)ake, (e)mpty, (c)ancel?: ')

            if choice == 'm' || choice == 'make'
                call ArtisanMake('command', a:command)
                call s:laravel_executor('e ' . command)
            elseif choice == 'e' || choice == 'empty'
                call s:laravel_executor('e ' . command)
            else
                echo "\nOperation cancelled."
            endif

        elseif (g:laravel_vim_create_if_not_exists == 'empty')
            call s:laravel_executor('e ' . command)

        elseif (g:laravel_vim_create_if_not_exists == 'artisan')
            call ArtisanMake('command', a:command)
            call s:laravel_executor('e ' . command)
        endif
    endif
endfunction

command! -nargs=* Artisan call Artisan(<f-args>)
command! -nargs=* Aapp call ArtisanApp(<f-args>)
command! -nargs=* Aauth call ArtisanAuth(<f-args>)
command! -nargs=* Acache call ArtisanCache(<f-args>)
command! -nargs=* Aconfig call ArtisanConfig(<f-args>)
command! -nargs=* Adb call ArtisanDb(<f-args>)
command! -nargs=* Aevent call ArtisanEvent(<f-args>)
command! -nargs=* Ahandler call ArtisanHandler(<f-args>)
command! -nargs=* Akey call ArtisanKey(<f-args>)
command! -nargs=* Amake call ArtisanMake(<f-args>)
command! -nargs=* Amigrate call ArtisanMigrate(<f-args>)
command! -nargs=* Aqueue call ArtisanQueue(<f-args>)
command! -nargs=* Aroute call ArtisanRoute(<f-args>)
command! -nargs=* Asession call ArtisanSession(<f-args>)
command! -nargs=* Avendor call ArtisanVendor(<f-args>)

command! -nargs=* Lcontroller call LaravelController(<f-args>)
command! -nargs=* Lmodel call LaravelModel(<f-args>)
command! -nargs=* Lcommand call LaravelCommand(<f-args>)