module misc.singleton;

/**
    D makes it possible.
    Just use:
        class MyClass
        {
            mixin Singleton!(MyClass);

            void doSomeTthing()
            {
                // do something
            };
        }

        MyClass.instance.doSomething(); // create and use a unique instance

    to make a singleton out of a normal class;


    Singleton : simple-singleton
    StartupSingleton : created at startup
    ThreadSafeSingleton : thread-safe singleton, prevent two concurrent creation

*/

template Singleton() // object is created on demand
{
    public static final typeof(this) instance ()
    {
        if (_instance is null )
        {
            _instance = new typeof(this)();
        }
        return _instance;
    }

    public static final void release()
    {
        delete _instance;
    }

    private static typeof(this) _instance = null;
}

template ThreadSafeSingleton() // object creation is synchronized
{
    public static final typeof(this) instance ()
    {
        if (_instance is null )
        {
            synchronized
            {
                if (_instance is null )
                {
                    _instance = new typeof(this)();
                }
            }
        }
        return _instance;
    }

    public static final void release()
    {
        delete _instance;
    }

    private static T _instance = null;
}

template StartupSingleton() // object is created at startup
{
    static this()
    {
        _instance = new typeof(this)();
    }

    public static final typeof(this) instance ()
    {
        return _instance;
    }

    public static final void release()
    {
        delete _instance;
    }

    private static typeof(this) _instance = null;
}
