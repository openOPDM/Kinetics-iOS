//
//  MAPST.hpp
//  MobilityApp
//
//  Created by Void on 28.02.13.
//  Copyright (c) 2013 Kinetics Foundation. All rights reserved.
//

#ifndef MobilityApp_MAPST_hpp
#define MobilityApp_MAPST_hpp

namespace MAPST
{
    template <class Iterator>
    double JERK(Iterator t_begin, Iterator t_end, Iterator x_begin, Iterator y_begin, Iterator z_begin)
    {
        t_begin++, x_begin++, y_begin++, z_begin++;
        size_t n = t_end - t_begin;
        
        if (t_begin == t_end)
        {
            return 0.0;
        }
        
        double dt = (*t_begin - *(t_begin - 1.0));
        double derv_x = (*x_begin - *(x_begin - 1.0))/dt;
        double derv_y = (*y_begin - *(y_begin - 1.0))/dt;
        double derv_z = (*z_begin - *(z_begin - 1.0))/dt;
        double prev_jerk = ((derv_x * derv_x) + (derv_y * derv_y) + (derv_z * derv_z));
        
        double jerk = 0.0;
        
        for (++t_begin, ++x_begin, ++y_begin;t_begin != t_end;++t_begin, ++x_begin, ++y_begin)
        {
            dt = (*t_begin - *(t_begin-1.0));
            derv_x = (*x_begin - *(x_begin - 1.0))/dt;
            derv_y = (*y_begin - *(y_begin - 1.0))/dt;
            derv_z = (*z_begin - *(z_begin - 1.0))/dt;
            double curr_jerk = ((derv_x * derv_x) + (derv_y * derv_y) + (derv_z * derv_z));
            jerk += (prev_jerk + curr_jerk);
            prev_jerk = curr_jerk;
        }
        
        return 0.5*jerk/n;
    }
    
    template <class Iterator>
    double distance(Iterator t_begin, Iterator t_end, Iterator x_begin, Iterator y_begin, Iterator z_begin)
    {
        double duration = *(t_end - 1.0) - *t_begin;
        double dist = 0.0;
        
        double prev_dist = 0.0;
        
        for (++t_begin, ++x_begin, ++y_begin, ++z_begin;t_begin != t_end;++t_begin, ++x_begin, ++y_begin, ++z_begin)
        {
            double dt = (*t_begin - *(t_begin - 1));
            double x = *x_begin , y = *y_begin, z = *z_begin;
            double curr_dist = std::sqrt(x*x+y*y+z*z);
            dist += dt*(prev_dist + curr_dist);
            prev_dist = curr_dist;
        }
        
        return (0.5*dist)/duration;
    }
    
    template <class Iterator>
    double RMS(Iterator t_begin, Iterator t_end, Iterator x_begin, Iterator y_begin, Iterator z_begin)
    {
        size_t n = t_end - t_begin;
        double sum = 0.0;
        for (;t_begin != t_end;++t_begin, ++x_begin, ++y_begin, ++z_begin)
        {
            double x = *x_begin, y = *y_begin, z = *z_begin;
            sum += x*x + y*y + z*z;
        }
        return std::sqrt(sum/n);
    }
    
    template <class Iterator>
    double path(Iterator t_begin, Iterator t_end, Iterator x_begin, Iterator y_begin, Iterator z_begin)
    {
        double path = 0.0;
        for (++t_begin, ++x_begin, ++y_begin, ++z_begin;t_begin != t_end;++t_begin, ++x_begin, ++y_begin, ++z_begin)
        {
            double x = *x_begin , y = *y_begin, z = *z_begin;
            double prev_x = *(x_begin - 1.0) , prev_y = *(y_begin - 1.0), prev_z = *(z_begin - 1.0);
            path += std::sqrt((x - prev_x)*(x - prev_x) + (y - prev_y)*(y - prev_y) + (z - prev_z)*(z - prev_z));
        }
        
        return path;
    }
    
    inline double MF(double path, double dist, double duration)
    {
        return path/(2.0*M_PI*dist*duration);
    }
    
    inline double AREA(double dist, double duration)
    {
        return (2.0*M_PI*dist)/duration;
    }
}

#endif
