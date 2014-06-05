require "gamedata"
require "character"
require "enemy"
require "entity"
require "List"
World = {
	background = love.graphics.newImage("world_bg.jpg"),
	character = Character(),
	bullets = List(),
	enemies = {
		enemies = List(),
		enemyTimer = 3

	},
	enemyBullets = List(),
	shader = love.graphics.newShader [[
		extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
        	vec3 outCol = vec3(abs(sin(time)), 0.0, 0.0);
        	return vec4(outCol, 1.0);
		}
	]],
	MountainShader = love.graphics.newShader [[
		vec4 mod289(vec4 x)
		{
		    return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		vec4 permute(vec4 x)
		{
		    return mod289(((x*34.0)+1.0)*x);
		}

		vec4 taylorInvSqrt(vec4 r)
		{
		    return 1.79284291400159 - 0.85373472095314 * r;
		}

		vec2 fade(vec2 t) {
		    return t*t*t*(t*(t*6.0-15.0)+10.0);
		}

		float cnoise(vec2 P)
		{
			vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
		    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
		    Pi = mod289(Pi); // To avoid truncation effects in permutation
		    vec4 ix = Pi.xzxz;
		    vec4 iy = Pi.yyww;
		    vec4 fx = Pf.xzxz;
		    vec4 fy = Pf.yyww;
		     
		    vec4 i = permute(permute(ix) + iy);
		     
		    vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
		    vec4 gy = abs(gx) - 0.5 ;
		    vec4 tx = floor(gx + 0.5);
		    gx = gx - tx;
		     
		    vec2 g00 = vec2(gx.x,gy.x);
		    vec2 g10 = vec2(gx.y,gy.y);
		    vec2 g01 = vec2(gx.z,gy.z);
		    vec2 g11 = vec2(gx.w,gy.w);
		     
		    vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
		    g00 *= norm.x;  
		    g01 *= norm.y;  
		    g10 *= norm.z;  
		    g11 *= norm.w;  
		     
		    float n00 = dot(g00, vec2(fx.x, fy.x));
		    float n10 = dot(g10, vec2(fx.y, fy.y));
		    float n01 = dot(g01, vec2(fx.z, fy.z));
		    float n11 = dot(g11, vec2(fx.w, fy.w));
		     
		    vec2 fade_xy = fade(Pf.xy);
		    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
		    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
		    return 2.3 * n_xy;
		}

		float fBm (vec2 p, float octaves, float lacunarity, float gain)
		{
			float amp = 1;
			vec2 pp = p;
			float sum = 0;
			float i;

			for (i = 0;  i < octaves;  i += 1) {
				amp *= gain;
				sum += amp * cnoise (pp);
				pp *= lacunarity;
			}
			return sum;
		}

		float RidgedMultifractal(vec2 p, int octaves, float lacunarity, float gain, float H, float sharpness, float threshold)
		{
			float result, signal, weight, i, exponent;
			vec2 PP=p;

			for(i=0; i<octaves; i += 1 ) {
		       	if ( i == 0) {
	          		signal = cnoise( PP );
	          		if ( signal < 0.0 ) signal = -signal;
	          		signal = gain - signal;
	          		signal = pow( signal, sharpness );
	          		result = signal;
	          		weight = 1.0;
	        	}else{
	          		exponent = pow( lacunarity, (-i*H) );
				PP = PP * lacunarity;
	          		weight = signal * threshold;
	          		weight = clamp(weight,0,1)    ;    		
	          		signal = cnoise( PP );
	          		signal = abs(signal);
	          		signal = gain - signal;
	          		signal = pow( signal, sharpness );
	          		signal *= weight;
	          		result += signal * exponent;
	       		}
			}
			return(result);
		}

		extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {	
        	//vec4 outCol = vec4((abs(sin((texture_coords.x+texture_coords.y))/2)+1)/2, (abs(sin(texture_coords.x+time))+1)/2, (abs(sin(texture_coords.y))+1)/2, 1.0)*0.5;
            float x = time+texture_coords.x;
            //float mountainTop = ((sin(x*3.14/5)*2+cos(x*3.14*6)*0.1+(cos(x*3.14)*cos(x*3.14)))+1)*sin(x*3.14/18)*sin(x3.14/18)/4;
            float mountainTop = ((sin(x*3.14/5)*2+cos(x*3.14*6)*0.1+(cos(x*3.14)*cos(x*3.14)))+1)*sin(x*3.14/9)*sin(x*3.14/9)/16+0.1;
            mountainTop = clamp(mountainTop, smoothstep(0.05, 0.1, mountainTop)/20+0.05, 10.0);
            vec3 grass = vec3(0.0, 1.0, 0.0);
            vec3 snow = vec3(1.0, 1.0, 1.0);
            vec3 stone = vec3(0.4, 0.4, 0.4);
            vec3 sky = vec3(0.6, 0.8, 1.0);
            vec3 outCol = grass;// mix(grass, stone, step(mountainTop*0.2+0.1, 1-texture_coords.y));
            outCol = mix(outCol, snow, step(mountainTop*0.8, 1-texture_coords.y));
            float blend = smoothstep(mountainTop, mountainTop+0.01, 1-texture_coords.y);

            x = time*0.5+11+texture_coords.x*2;
            mountainTop = 1-min(abs(cos(x*3.14/2)),min(abs(cos(x*3.14/2-0.3))+0.1, abs(cos(x*3.14/2+0.3))+0.1))-0.2;
            //mountainTop = ((sin(x*3.14/5)*2+cos(x*3.14*6)*0.1+(cos(x*3.14)*cos(x*3.14)))+1)*sin(x*3.14/9)*sin(x*3.14/9)/6+0.1;
            //mountainTop2 = clamp(mountainTop2, smoothstep(0.05, 0.1, mountainTop)/20+0.15, 10.0);
            //vec3 outCol2 = mix(grass, stone, step(mountainTop*0.2+0.1, 1-texture_coords.y));
            vec3 outCol2 = mix(stone, snow, smoothstep(0.44+mountainTop/5, 0.45+abs(cnoise(vec2(x, 0))/20)+mountainTop/5, 1-texture_coords.y));
            //outCol2 = mix(outCol2, sky, smooth(mountainTop, mountainTop+0.05, 1-texture_coords.y));
            outCol2 = mix(outCol2, vec3(0.5, 0.5, 0.5), 0.3);
            
            float blend2 = smoothstep(mountainTop, mountainTop+0.01, 1-texture_coords.y);

        
            x = time*0.4+26 +texture_coords.x*2;
            x += cnoise(vec2(x, 0))/4;

            mountainTop = 1-min(abs(cos(x*3.14/2)),min(abs(cos(x*3.14/2-0.3))+0.1, abs(cos(x*3.14/2+0.3))+0.1));
            //mountainTop2 = clamp(mountainTop2, smoothstep(0.05, 0.1, mountainTop)/20+0.15, 10.0);
            //vec3 outCol2 = mix(grass, stone, step(mountainTop*0.2+0.1, 1-texture_coords.y));
            vec3 outCol3 = mix(stone, snow, smoothstep(0.54+mountainTop/5, 0.55+abs(cnoise(vec2(x, 0))/20)+mountainTop/5, 1-texture_coords.y));
            outCol3 = mix(outCol3, sky, smoothstep(mountainTop, mountainTop+0.01, 1-texture_coords.y));
            outCol3 = mix(outCol3, vec3(0.5, 0.5, 0.5), 0.4);

            outCol2 = mix(outCol2, outCol3, blend2);
            outCol = mix(outCol, outCol2, blend);
            return vec4(outCol, 1.0);
        }
	]],
	LavaMountainShader = love.graphics.newShader [[
		varying vec4 vpos;

		#ifdef VERTEX

		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			vpos = vertex_position;
        	return transform_projection * vpos;
		}
    	#endif

		#ifdef PIXEL
		extern number time;

		vec4 mod289(vec4 x)
		{
		    return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		vec4 permute(vec4 x)
		{
		    return mod289(((x*34.0)+1.0)*x);
		}

		vec4 taylorInvSqrt(vec4 r)
		{
		    return 1.79284291400159 - 0.85373472095314 * r;
		}

		vec2 fade(vec2 t) {
		    return t*t*t*(t*(t*6.0-15.0)+10.0);
		}

		float cnoise(vec2 P)
		{
			vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
		    vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
		    Pi = mod289(Pi); // To avoid truncation effects in permutation
		    vec4 ix = Pi.xzxz;
		    vec4 iy = Pi.yyww;
		    vec4 fx = Pf.xzxz;
		    vec4 fy = Pf.yyww;
		     
		    vec4 i = permute(permute(ix) + iy);
		     
		    vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
		    vec4 gy = abs(gx) - 0.5 ;
		    vec4 tx = floor(gx + 0.5);
		    gx = gx - tx;
		     
		    vec2 g00 = vec2(gx.x,gy.x);
		    vec2 g10 = vec2(gx.y,gy.y);
		    vec2 g01 = vec2(gx.z,gy.z);
		    vec2 g11 = vec2(gx.w,gy.w);
		     
		    vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
		    g00 *= norm.x;  
		    g01 *= norm.y;  
		    g10 *= norm.z;  
		    g11 *= norm.w;  
		     
		    float n00 = dot(g00, vec2(fx.x, fy.x));
		    float n10 = dot(g10, vec2(fx.y, fy.y));
		    float n01 = dot(g01, vec2(fx.z, fy.z));
		    float n11 = dot(g11, vec2(fx.w, fy.w));
		     
		    vec2 fade_xy = fade(Pf.xy);
		    vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
		    float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
		    return 2.3 * n_xy;
		}

		float fBm (vec2 p, float octaves, float lacunarity, float gain)
		{
			float amp = 1;
			vec2 pp = p;
			float sum = 0;
			float i;

			for (i = 0;  i < octaves;  i += 1) {
				amp *= gain;
				sum += amp * cnoise (pp);
				pp *= lacunarity;
			}
			return sum;
		}

		float RidgedMultifractal(vec2 p, int octaves, float lacunarity, float gain, float H, float sharpness, float threshold)
		{
			float result, signal, weight, i, exponent;
			vec2 PP=p;

			for(i=0; i<octaves; i += 1 ) {
		       	if ( i == 0) {
		          		signal = cnoise( PP );
		          		if ( signal < 0.0 ) signal = -signal;
		          		signal = gain - signal;
		          		signal = pow( signal, sharpness );
		          		result = signal;
		          		weight = 1.0;
		        	}else{
		          		exponent = pow( lacunarity, (-i*H) );
					PP = PP * lacunarity;
		          		weight = signal * threshold;
		          		weight = clamp(weight,0,1)    ;    		
		          		signal = cnoise( PP );
		          		signal = abs(signal);
		          		signal = gain - signal;
		          		signal = pow( signal, sharpness );
		          		signal *= weight;
		          		result += signal * exponent;
		       		}
				}
				return(result);
		}
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
        	float magnitude = abs(RidgedMultifractal((pixel_coords+vec2(time, 0)*5)*0.002,7, 2.5, 0.9, 0.8, 4, 8)*120.00001);
			float mountainAtt=distance(vpos.z,100)/1000.0;
				
		    float res = magnitude*mountainAtt;
		    clamp(res, 0, 10000);
		    res /= 25;
			vec3 Diffuse=vec3(1.0, 1.0, 1.0)*res;
			return vec4(Diffuse*vec3(1,0.8,0.4+time-time), 1.0);
    	}

    	#endif


	]],
	quad = love.graphics.newQuad(0, 0, 800, 600, 800, 600),
	canvas = love.graphics.newCanvas(800, 600)
}

function World.draw(this)
	this.MountainShader:send("time", GameData.timeElapsed)
	love.graphics.setShader(this.MountainShader)
	love.graphics.draw(this.canvas, this.quad, 0, 0)
	love.graphics.setShader()
	this.character:draw()

	while this.enemies.enemies:next() do
		this.enemies.enemies.iterator:draw()
	end
	while this.bullets:next() do
		this.bullets.iterator:draw()
	end
end

function World.update(this, delta)
	this.character:update(delta, this.bullets)
	while this.bullets:next() do
		if this.bullets.iterator.dying then
			this.bullets:remove(this.bullets.iteratorAt)
		else
			this.bullets.iterator:update(delta, this.enemies.enemies)
		end
	end
	while this.enemies.enemies:next() do
		this.enemies.enemies.iterator:update(delta)
		if this.enemies.enemies.iterator.dying then
			this.enemies.enemies:remove(this.enemies.enemies.iteratorAt)
		else
			this.enemies.enemies.iterator:update(delta, this.enemies.enemies)
		end
	end
	if this.enemies.enemyTimer < GameData.timeElapsed then
		this.enemies.enemyTimer = this.enemies.enemyTimer + 1.4
		this.enemies.enemies:add(enemy(300, 100))
	end
end

function World.load(this)
	this.character:load()
	y = entity()
	
end