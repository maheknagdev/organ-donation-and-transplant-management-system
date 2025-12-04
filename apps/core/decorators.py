from django.shortcuts import redirect
from django.contrib import messages
from functools import wraps


def login_required_custom(view_func):
    """Require user to be logged in"""
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.session.get('user_id'):
            messages.error(request, 'Please login to access this page')
            return redirect('core:login')
        return view_func(request, *args, **kwargs)
    return wrapper


def role_required(*allowed_roles):
    """Require specific role(s) to access view"""
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            if not request.session.get('user_id'):
                messages.error(request, 'Please login to access this page')
                return redirect('core:login')
            
            user_role = request.session.get('role')
            if user_role not in allowed_roles:
                messages.error(request, f'Access denied. This page is only for: {", ".join(allowed_roles)}')
                return redirect('core:dashboard')
            
            return view_func(request, *args, **kwargs)
        return wrapper
    return decorator