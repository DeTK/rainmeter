if !A_isAdmin
{
    run, *runas %A_ScriptFullPath%
}
Run, C:\Users\DeTK\Desktop\start.bat