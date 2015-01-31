function [x,y]=squareg(bs,s)

nbs=4;

if nargin==0,
  x=nbs; % number of boundary segments
  return
end

d=[
  0 0 0 0 % start parameter value
  1 1 1 1 % end parameter value
  1 1 1 1 % left hand region
  0 0 0 0 % right hand region
];

bs1=bs(:)';

if find(bs1<1 | bs1>nbs),
  error('squareg:InvalidBs', 'Non existent boundary segment number.')
end

if nargin==1,
  x=d(:,bs1);
  return
end

x=zeros(size(s));
y=zeros(size(s));
[m,n]=size(bs);
if m==1 && n==1,
  bs=bs*ones(size(s)); % expand bs
elseif m~=size(s,1) || n~=size(s,2),
  error('squareg:SizeBs', 'bs must be scalar or of same size as s.');
end

if ~isempty(s),
  % boundary segment 1
  ii=find(bs==1);
  x(ii) = s(ii);
  y(ii) = zeros(size(ii));

  % boundary segment 2
  ii=find(bs==2);
  x(ii) = ones(size(ii));
  y(ii) = s(ii);

  % boundary segment 3
  ii=find(bs==3);
  x(ii) = 1-s(ii);
  y(ii) = ones(size(ii));

  % boundary segment 4
  ii=find(bs==4);
  x(ii) = zeros(size(ii));
  y(ii) = 1-s(ii);
end
