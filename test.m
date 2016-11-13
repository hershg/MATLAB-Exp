function [N, names] = PlayerData(colors)

%% FIGURE WINDOW
res = get(0, 'ScreenSize');
fig = ...
figure('Name', 'Player Input', ...
       'Units', 'pixels', ...
       'MenuBar', 'none', ...
       'NumberTitle', 'off', ...
       'Position', [res(3:4)/3, 300, 300]);


%% DROP-DOWN TO SELECT NUMBER OF PLAYERS
uicontrol('style', 'text', ...
          'Units', 'normalized', ...
          'Parent', fig, ...
          'BackgroundColor', get(gcf, 'Color'), ...
          'Position', [0, 0.88, 0.45, 0.08], ...
          'HorizontalAlignment', 'right', ...
          'String', 'Number of players: ');

drop = ...
uicontrol('style', 'popupmenu', ...
          'Units', 'normalized', ...
          'Parent', fig, ...
          'BackgroundColor', [1 1 1], ...
          'String', {'2','3','4','5','6'}, ...
          'Value', 1, ...
          'Position', [0.65, 0.88, 0.1, 0.1], ...
          'Callback', {@DropdownCallback, fig});

field = zeros(1,6);
for i = 1:6
    uicontrol('style', 'text', ...
              'Units', 'normalized', ...
              'Parent', fig, ...
              'BackgroundColor', get(gcf, 'Color'), ...
              'Position', [0.03, .9 - i* 0.13, 0.47, 0.08], ...
              'HorizontalAlignment', 'right', ...
              'String', sprintf('Player %d (%s): ', i, colors{i}));
    
    field(i) = ...
    uicontrol('style', 'edit', ...
              'Units', 'normalized', ...
              'Parent', fig, ...
              'BackgroundColor', get(gcf, 'Color'), ...
              'Enable', 'inactive', ...
              'Position', [0.5, .92 - i* 0.13, 0.45, 0.08], ...
              'String', sprintf('Player %d', i));         
end

uicontrol('style', 'pushbutton', ...
          'Parent', fig, ...
          'String', 'OK', ...
          'Units' , 'normalized', ...
          'Position', [0.45, 0.03, 0.15, 0.08], ...
          'Callback', 'uiresume(gcf)')

DropdownCallback(drop, 0, fig)
uiwait(fig);
N = get(drop, 'Value') + 1;
names = cell(1,N);
for i = 1:N
    names{i} = get(field(i), 'String');
end
delete(fig)

function DropdownCallback(drop, ~, fig)
 
N = get(drop, 'Value') + 1;
text = findobj('Parent', fig, 'style', 'edit');

for i = 1:6
    if i <= N
        set(text(7 - i), 'BackgroundColor', [1 1 1], 'Enable', 'on');
    else
        set(text(7 - i), 'BackgroundColor', get(fig,'Color'), 'Enable', 'inactive');
    end
end

