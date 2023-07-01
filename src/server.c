/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   server.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dacortes <dacortes@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/06/09 18:12:53 by dacortes          #+#    #+#             */
/*   Updated: 2023/07/01 12:15:42 by dacortes         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include"../inc/minitalk.h"

void	handler(int sig)
{
	static int				bite = 0;
	static unsigned char	ch = '\0';

	ch <<= 1;
	if (sig == SIGUSR1)
		ch |= 1;
	bite++;
	if (bite == 8)
	{
		if ((int)ch <= 126)
			ft_printf("%c", ch);
		else if ((int)ch >= 127)
			ft_printf("%c", ch);
		bite = 0;
		ch = '\0';
	}
}

void	confirm(void)
{
	struct sigaction	sa;

	sa.sa_handler = handler;
	sa.sa_flags = SA_RESTART;
	if (sigaction(SIGUSR1, &sa, NULL) == ERROR)
		exit(EXIT_FAILURE);
	if (sigaction(SIGUSR2, &sa, NULL) == ERROR)
		exit(EXIT_FAILURE);
}

int	main(void)
{
	pid_t	pid;

	pid = getpid();
	if (!pid)
		ft_printf("NO PID");
	else
		ft_printf("Server PID: %i\n", getpid());
	confirm();
	while (TRUE)
		sleep(1);
	return (SUCCESS);
}
